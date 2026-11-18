import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/db/app_database.dart';
import '../../../core/domain/cardio.dart';
import '../../../core/domain/enums.dart';
import '../../../core/domain/load.dart';
import '../../../core/domain/plates.dart';
import '../../../core/domain/superset.dart';
import '../../../core/platform/rest_notifications.dart';
import '../../../core/prefs/prefs_repository.dart';
import '../../../core/utils/plural.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/value_stepper.dart';
import '../../catalog/presentation/exercise_picker_sheet.dart';
import '../../gyms/data/station_repository.dart';
import '../../gyms/presentation/equipment_picker_sheet.dart';
import '../data/workout_repository.dart';
import 'widgets/elapsed_text.dart';
import 'widgets/rest_bar.dart';
import 'widgets/session_exercise_card.dart';

/// "Treino em andamento" — tela cheia, fora das abas. O estado mora no
/// banco: fechar o app e reabrir volta exatamente aqui.
class ActiveSessionScreen extends ConsumerStatefulWidget {
  const ActiveSessionScreen({super.key, required this.sessionId});
  final String sessionId;

  @override
  ConsumerState<ActiveSessionScreen> createState() =>
      _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends ConsumerState<ActiveSessionScreen> {
  /// Série tocada pela pessoa (null = a próxima pendente, automática).
  String? _focusedSetId;

  /// Exercício recém-adicionado/trocado: a próxima série sai dele.
  String? _focusedExerciseId;

  /// Para rolar até o exercício da vez (os ajustes dele ficam à vista).
  final _cardKeys = <String, GlobalKey>{};
  String? _lastSelectedExerciseId;

  bool _completing = false;
  bool _finishing = false;

  @override
  void initState() {
    super.initState();
    // listenManual mantém a preferência viva enquanto a tela existir
    // (ler `.future` de um provider autoDispose sem ouvir o descarta antes
    // de carregar) e reage se ela mudar.
    ref.listenManual(keepScreenOnProvider, (_, next) {
      final on = next.value;
      if (on != null) _setWakelock(on);
    }, fireImmediately: true);
    // No primeiro treino, pede a notificação (timer na tela bloqueada).
    // Se já estiver liberada, não pergunta nada.
    RestNotifications.instance.ensurePermission();
  }

  /// Tela ligada é conforto, não pode derrubar o treino se a plataforma falhar.
  void _setWakelock(bool on) {
    (on ? WakelockPlus.enable() : WakelockPlus.disable()).catchError(
      (Object _) {},
    );
  }

  @override
  void dispose() {
    _setWakelock(false);
    super.dispose();
  }

  WorkoutRepository get _repo => ref.read(workoutRepositoryProvider);

  /// A série que a zona do polegar está editando.
  ({SessionExerciseView view, WorkoutSet set, int number})? _selected(
    List<SessionExerciseView> exercises,
    Map<String, List<WorkoutSet>> sets,
  ) {
    ({SessionExerciseView view, WorkoutSet set, int number}) pack(
      SessionExerciseView v,
      WorkoutSet s,
    ) => (
      view: v,
      set: s,
      number: workingNumber(sets[v.item.id] ?? const <WorkoutSet>[], s),
    );

    ({SessionExerciseView view, WorkoutSet set, int number})? firstPendingOf(
      SessionExerciseView v,
    ) {
      final s = (sets[v.item.id] ?? const <WorkoutSet>[])
          .where((s) => s.completedAt == null)
          .firstOrNull;
      return s == null ? null : pack(v, s);
    }

    if (_focusedSetId != null) {
      for (final v in exercises) {
        for (final s in sets[v.item.id] ?? const <WorkoutSet>[]) {
          if (s.id == _focusedSetId) return pack(v, s);
        }
      }
    }
    if (_focusedExerciseId != null) {
      final v = exercises
          .where((e) => e.item.id == _focusedExerciseId)
          .firstOrNull;
      final pick = v == null ? null : firstPendingOf(v);
      if (pick != null) return pick;
    }
    for (final v in exercises) {
      final pick = firstPendingOf(v);
      if (pick != null) return pick;
    }
    return null;
  }

  /// Quando o exercício da vez muda, rola até o cartão dele: os ajustes da
  /// máquina precisam aparecer sem nenhum toque.
  void _scrollToIfChanged(String? exerciseId) {
    if (exerciseId == null || exerciseId == _lastSelectedExerciseId) return;
    _lastSelectedExerciseId = exerciseId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _cardKeys[exerciseId]?.currentContext;
      if (ctx != null && ctx.mounted) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _complete(
    WorkoutSession session,
    SessionExerciseView view,
    WorkoutSet set,
  ) async {
    if (_completing) return;
    setState(() => _completing = true);
    final repo = _repo; // capturado: o "Desfazer" pode rodar depois
    // Bi-set: vai para o par sem descanso; descansa ao fechar a rodada.
    final step = _supersetNext(session, view, set);
    try {
      final ok = await repo.completeSet(
        set.id,
        sessionId: session.id,
        restSec: step != null && !step.rest ? 0 : view.item.restSec,
      );
      if (!mounted) return;
      if (!ok) {
        setState(() => _focusedSetId = set.id);
        showSnack(
          context,
          view.exercise.tracking == TrackingType.weightReps
              ? 'Informe as repetições antes de concluir.'
              : 'Informe o tempo antes de concluir.',
        );
        return;
      }
      final record = await repo.liveRecord(set.id);
      await (record == null
          ? HapticFeedback.mediumImpact()
          : HapticFeedback.heavyImpact());
      if (!mounted) return;
      // Próxima: segue no mesmo exercício; se acabou, a próxima pendente.
      setState(() {
        _focusedSetId = null;
        _focusedExerciseId = step?.view.item.id ?? view.item.id;
      });
      showSnack(
        context,
        record != null
            ? '🏆 Recorde de ${record.kind.label.toLowerCase()}: '
                  '${record.value}'
            : step != null && !step.rest
            ? 'Agora, sem descanso: ${step.view.exercise.name}'
            : 'Série concluída',
        actionLabel: 'Desfazer',
        duration: const Duration(seconds: 5),
        onAction: () async {
          await repo.uncompleteSet(set.id);
          await repo.setRestEndsAt(session.id, null);
          if (mounted) setState(() => _focusedSetId = set.id);
        },
      );
    } finally {
      // Segura um instante: toque duplo não conclui a próxima série.
      await Future<void>.delayed(const Duration(milliseconds: 450));
      if (mounted) setState(() => _completing = false);
    }
  }

  /// Num bi-set, o exercício da próxima série e se descansa antes dela.
  /// Null fora de bi-set (ou com o grupo terminado).
  ({SessionExerciseView view, bool rest})? _supersetNext(
    WorkoutSession session,
    SessionExerciseView view,
    WorkoutSet done,
  ) {
    final exercises =
        ref.read(sessionExercisesProvider(session.id)).value ?? const [];
    final sets = ref.read(sessionSetsProvider(session.id)).value ?? const {};
    final index = exercises.indexWhere((e) => e.item.id == view.item.id);
    if (index < 0) return null;
    final members = supersetMembers([
      for (final e in exercises) e.item.supersetGroup,
    ], index);
    if (members.length < 2) return null;
    final step = supersetStep([
      for (final m in members)
        (sets[exercises[m].item.id] ?? const <WorkoutSet>[]).any(
          (s) => s.completedAt == null && s.id != done.id,
        ),
    ], members.indexOf(index));
    if (step == null) return null;
    return (view: exercises[members[step.next]], rest: step.rest);
  }

  Future<void> _addExercise(WorkoutSession session) async {
    final exercise = await showExercisePicker(context, gymId: session.gymId);
    if (exercise == null || !mounted) return;
    final choice = await chooseEquipment(
      context,
      ref,
      gymId: session.gymId,
      exercise: exercise,
    );
    if (choice == null || !mounted) return;
    final repo = _repo;
    final rest = await ref.read(prefsRepositoryProvider).defaultRestSec();
    final id = await repo.addExercise(
      sessionId: session.id,
      exerciseId: exercise.id,
      equipmentId: choice.equipmentId,
      restSec: rest,
    );
    _focusExercise(id);
    if (choice.automatic && choice.equipmentId != null && mounted) {
      showSnack(
        context,
        'No aparelho da última vez: ${choice.label}',
        actionLabel: 'Trocar',
        onAction: () async {
          if (!mounted) return;
          final pick = await showEquipmentPicker(
            context,
            gymId: session.gymId,
            exercise: exercise,
            currentEquipmentId: choice.equipmentId,
          );
          if (pick == null) return;
          _focusExercise(await repo.swapEquipment(id, pick.equipmentId));
        },
      );
    }
  }

  void _focusExercise(String sessionExerciseId) {
    if (!mounted) return;
    setState(() {
      _focusedSetId = null;
      _focusedExerciseId = sessionExerciseId;
    });
  }

  Future<void> _finish(WorkoutSession session) async {
    if (_finishing) return;
    _finishing = true;
    try {
      final counts = await _repo.setCounts(session.id);
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      if (counts.done == 0) {
        final discard = await showConfirmDialog(
          context,
          title: 'Nenhuma série concluída',
          message: 'Descartar este treino?',
          confirmLabel: 'Descartar',
          destructive: true,
        );
        if (!discard || !mounted) return;
        messenger.clearSnackBars(); // nenhum "Desfazer" sobrevive ao treino
        await _repo.discardSession(session.id);
        if (mounted) context.pop();
        return;
      }
      final ok = await showConfirmDialog(
        context,
        title: 'Finalizar treino?',
        message: counts.pending > 0
            ? '${plural(counts.pending, 'série não feita será descartada', 'séries não feitas serão descartadas')}.'
            : 'Bom treino! Tudo fica salvo no histórico.',
        confirmLabel: 'Finalizar',
      );
      if (!ok || !mounted) return;
      messenger.clearSnackBars();
      await _repo.finishSession(session.id);
      if (!mounted) return;
      // Vai direto para o resumo (duração, volume, recordes).
      ref.read(routerProvider).go('/progresso/sessao/${session.id}');
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Treino salvo: ${plural(counts.done, 'série', 'séries')}. 💪',
          ),
        ),
      );
    } finally {
      _finishing = false;
    }
  }

  Future<void> _adjustRest(WorkoutSession session, int seconds) async {
    final now = DateTime.now();
    final current = session.restEndsAt;
    final base = (current == null || current.isBefore(now)) ? now : current;
    var next = base.add(Duration(seconds: seconds));
    if (next.isBefore(now)) next = now;
    await _repo.setRestEndsAt(session.id, next);
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(sessionProvider(widget.sessionId));
    // Assistidos já aqui: carregam em paralelo com a sessão.
    final exercisesAsync = ref.watch(
      sessionExercisesProvider(widget.sessionId),
    );
    final setsAsync = ref.watch(sessionSetsProvider(widget.sessionId));
    final session = sessionAsync.value;

    if (session == null || session.endedAt != null) {
      return Scaffold(
        appBar: AppBar(),
        body: sessionAsync.isLoading && session == null
            ? const Center(child: CircularProgressIndicator())
            : const EmptyState(
                icon: Icons.check_circle_outline,
                title: 'Este treino já foi finalizado',
                message: 'Ele está no histórico, na aba Progresso.',
              ),
      );
    }
    if (!exercisesAsync.hasValue || !setsAsync.hasValue) {
      return Scaffold(
        appBar: AppBar(title: Text(session.title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final exercises = exercisesAsync.requireValue;
    final sets = setsAsync.requireValue;
    final selected = _selected(exercises, sets);
    _scrollToIfChanged(selected?.view.item.id);
    final groups = [for (final e in exercises) e.item.supersetGroup];
    final restEndsAt = session.restEndsAt?.toLocal();
    final showRest =
        restEndsAt != null &&
        restEndsAt.isAfter(
          DateTime.now().subtract(const Duration(seconds: 30)),
        );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session.title),
            ElapsedText(
              since: session.startedAt,
              style: context.texts.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontFeatures: tabularFigures,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton.tonal(
              style: FilledButton.styleFrom(minimumSize: const Size(64, 48)),
              onPressed: () => _finish(session),
              child: const Text('Finalizar'),
            ),
          ),
        ],
      ),
      body: exercises.isEmpty
          ? EmptyState(
              icon: Icons.add_task,
              title: 'Treino livre',
              message:
                  'Adicione o primeiro exercício. Se você já fez ele neste '
                  'aparelho, os ajustes e as cargas da última vez vêm junto.',
              action: FilledButton.icon(
                onPressed: () => _addExercise(session),
                icon: const Icon(Icons.add),
                label: const Text('Adicionar exercício'),
              ),
            )
          : ListView(
              // Mantém todos os cartões montados: nada pisca nem recarrega
              // ao rolar (são poucos exercícios por treino).
              scrollCacheExtent: const ScrollCacheExtent.pixels(20000),
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
              children: [
                for (final (i, v) in exercises.indexed) ...[
                  SessionExerciseCard(
                    key: _cardKeys.putIfAbsent(v.item.id, GlobalKey.new),
                    view: v,
                    superset: supersetSlot(groups, i),
                    hasNext: i < exercises.length - 1,
                    sets: sets[v.item.id] ?? const [],
                    session: session,
                    selectedSetId: selected?.set.id,
                    onSelectSet: (s) => setState(() {
                      _focusedSetId = s.id;
                      _focusedExerciseId = v.item.id;
                    }),
                    onCompleteSet: (s) => _complete(session, v, s),
                    onReplaced: _focusExercise,
                  ),
                  if (i < exercises.length - 1 &&
                      groups[i] != null &&
                      groups[i] == groups[i + 1])
                    // Elo entre os exercícios do mesmo bi-set.
                    SizedBox(
                      height: 24,
                      child: Icon(
                        Icons.link,
                        size: 20,
                        color: context.semantic.attention,
                      ),
                    )
                  else
                    const SizedBox(height: 12),
                ],
                OutlinedButton.icon(
                  onPressed: () => _addExercise(session),
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar exercício'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(64, 56),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: exercises.isEmpty
          ? null
          : SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showRest)
                    RestBar(
                      endsAt: restEndsAt,
                      onAdjust: (s) => _adjustRest(session, s),
                      onSkip: () => _repo.setRestEndsAt(session.id, null),
                    ),
                  _ThumbPanel(
                    selected: selected,
                    completing: _completing,
                    onComplete: (v, s) => _complete(session, v, s),
                    onDone: () => setState(() => _focusedSetId = null),
                    onAddExercise: () => _addExercise(session),
                    onFinish: () => _finish(session),
                  ),
                ],
              ),
            ),
    );
  }
}

/// Zona do polegar (fixa na metade de baixo): carga, reps, RIR e CONCLUIR.
/// Cada toque grava no banco na hora.
/// Calculadora de anilhas sem toque: em barra, Smith e máquina de anilhas,
/// mostra o que pôr de cada lado. A carga anotada não inclui a barra (ela
/// fica no "Carrinho/barra" do aparelho).
String? _platesHint(SessionExerciseView view, WorkoutSet set) {
  final type = view.equipment?.type;
  final load = set.loadMilli;
  final unit = view.item.loadUnit;
  if (load == null ||
      load <= 0 ||
      unit == LoadUnit.plate ||
      view.item.loadBasis == LoadBasis.perHand ||
      !(type == EquipmentType.barbell ||
          type == EquipmentType.smith ||
          type == EquipmentType.plateLoaded)) {
    return null;
  }
  final r = plateLoadout(
    targetMilli: load,
    basis: view.item.loadBasis,
    platesMilli: unit == LoadUnit.lb ? standardPlatesLb : standardPlatesKg,
  );
  if (r == null || r.perSide.isEmpty) return null;
  final plates = r.perSide.map(formatLoadValue).join(' + ');
  return [
    'Cada lado: $plates',
    if (!r.exact) '(faltam ${formatLoadValue(r.leftoverMilli)})',
    if (view.equipment?.baseLoadMilli case final bar?)
      '· barra ${formatLoad(bar, unit)}',
  ].join(' ');
}

class _ThumbPanel extends ConsumerWidget {
  const _ThumbPanel({
    required this.selected,
    required this.completing,
    required this.onComplete,
    required this.onDone,
    required this.onAddExercise,
    required this.onFinish,
  });

  final ({SessionExerciseView view, WorkoutSet set, int number})? selected;
  final bool completing;
  final void Function(SessionExerciseView view, WorkoutSet set) onComplete;
  final VoidCallback onDone;
  final VoidCallback onAddExercise;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(workoutRepositoryProvider);
    final panelColor = context.colors.surfaceContainerHigh;
    final sel = selected;
    if (sel == null) {
      return Container(
        color: panelColor,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onAddExercise,
                icon: const Icon(Icons.add),
                label: const Text('Exercício'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(64, 56),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: onFinish,
                child: const Text('FINALIZAR'),
              ),
            ),
          ],
        ),
      );
    }

    final view = sel.view;
    final set = sel.set;
    final item = view.item;
    final unit = item.loadUnit;
    final done = set.completedAt != null;
    final setLabel = set.setType == SetType.working
        ? 'série ${sel.number}'
        : set.setType.label.toLowerCase();
    final settings =
        ref.watch(stationSettingsProvider(view.station.id)).value ?? const [];

    Future<void> typeLoad() async {
      final text = await showNumberInputDialog(
        context,
        title: 'Carga',
        initial: set.loadMilli == null ? '' : formatLoadValue(set.loadMilli),
        suffix: unit.label,
      );
      if (text == null) return;
      await repo.updateSet(set.id, loadMilli: Value(parseLoadMilli(text)));
    }

    final tracking = view.exercise.tracking;
    // Prancha: segundos; cardio: minutos (é como se pensa em cada um).
    final clockUnit = tracking == TrackingType.cardio ? 60 : 1;

    Future<void> typeTime() async {
      final text = await showNumberInputDialog(
        context,
        title: 'Tempo',
        initial: set.durationSec == null
            ? ''
            : formatNumber(set.durationSec! / clockUnit),
        suffix: clockUnit == 60 ? 'min' : 's',
      );
      if (text == null) return;
      await repo.updateSet(
        set.id,
        durationSec: Value(parseClock(text, plainUnitSec: clockUnit)),
      );
    }

    Future<void> typeKm() async {
      final text = await showNumberInputDialog(
        context,
        title: 'Distância',
        initial: set.distanceM == null ? '' : formatKmValue(set.distanceM),
        suffix: 'km',
      );
      if (text == null) return;
      await repo.updateSet(set.id, distanceM: Value(parseKm(text)));
    }

    final timeStepper = ValueStepper(
      key: ValueKey('time-${set.id}'),
      label: clockUnit == 60 ? 'Tempo (min)' : 'Tempo',
      value: set.durationSec,
      step: clockUnit == 60 ? 60 : 15,
      max: 6 * 3600,
      format: formatSeconds,
      onChanged: (v) => repo.updateSet(set.id, durationSec: Value(v)),
      onTapValue: typeTime,
      decreaseTooltip: 'Menos tempo',
      increaseTooltip: 'Mais tempo',
    );

    Future<void> typeReps() async {
      final text = await showNumberInputDialog(
        context,
        title: 'Repetições',
        initial: set.reps?.toString() ?? '',
      );
      final reps = int.tryParse((text ?? '').split(RegExp('[.,]')).first);
      if (reps != null) await repo.updateSet(set.id, reps: Value(reps));
    }

    return Container(
      color: panelColor,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${view.exercise.name} · $setLabel${done ? ' (concluída)' : ''}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.texts.labelLarge?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          // Os ajustes da máquina da vez, sempre à vista.
          if (settings.isNotEmpty)
            Text(
              settings
                  .map((s) => '${s.label} ${formatSettingValue(s)}')
                  .join(' · '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.texts.labelMedium?.copyWith(
                color: context.semantic.attention,
                fontWeight: FontWeight.w600,
              ),
            ),
          const SizedBox(height: 6),
          if (tracking == TrackingType.duration)
            timeStepper
          else if (tracking == TrackingType.cardio)
            Row(
              children: [
                Expanded(child: timeStepper),
                const SizedBox(width: 12),
                Expanded(
                  child: ValueStepper(
                    key: ValueKey('km-${set.id}'),
                    label: 'Distância (km)',
                    value: set.distanceM,
                    step: 100,
                    max: 200000,
                    format: formatKmValue,
                    onChanged: (v) =>
                        repo.updateSet(set.id, distanceM: Value(v)),
                    onTapValue: typeKm,
                    decreaseTooltip: 'Menos distância',
                    increaseTooltip: 'Mais distância',
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: ValueStepper(
                    key: ValueKey('load-${set.id}'),
                    label: 'Carga (${unit.label})',
                    value: set.loadMilli,
                    step: item.incrementMilli,
                    format: formatLoadValue,
                    onChanged: (v) =>
                        repo.updateSet(set.id, loadMilli: Value(v)),
                    onTapValue: typeLoad,
                    decreaseTooltip: 'Diminuir carga',
                    increaseTooltip: 'Aumentar carga',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ValueStepper(
                    key: ValueKey('reps-${set.id}'),
                    label: 'Repetições',
                    value: set.reps,
                    step: 1,
                    max: 999,
                    format: (v) => v?.toString() ?? '—',
                    onChanged: (v) => repo.updateSet(set.id, reps: Value(v)),
                    onTapValue: typeReps,
                    decreaseTooltip: 'Diminuir repetições',
                    increaseTooltip: 'Aumentar repetições',
                  ),
                ),
              ],
            ),
          if (_platesHint(view, set) case final hint?)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                hint,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.texts.labelMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                  fontFeatures: tabularFigures,
                ),
              ),
            ),
          const SizedBox(height: 8),
          if (tracking == TrackingType.weightReps)
            Row(
              children: [
                Text(
                  'RIR',
                  style: context.texts.labelMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                for (final r in const [0, 1, 2, 3, 4])
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: ChoiceChip(
                        label: SizedBox(
                          width: double.infinity,
                          child: Text(
                            r == 4 ? '4+' : '$r',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        showCheckmark: false,
                        selected: set.rir != null && set.rir!.round() == r,
                        onSelected: (on) => repo.updateSet(
                          set.id,
                          rir: Value(on ? r.toDouble() : null),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          if (tracking == TrackingType.weightReps) const SizedBox(height: 8),
          if (done)
            FilledButton.tonal(
              onPressed: onDone,
              child: const Text('PRONTO (valores salvos)'),
            )
          else
            FilledButton(
              onPressed: completing ? null : () => onComplete(view, set),
              style: FilledButton.styleFrom(minimumSize: const Size(64, 64)),
              child: Text('CONCLUIR ${setLabel.toUpperCase()}'),
            ),
        ],
      ),
    );
  }
}
