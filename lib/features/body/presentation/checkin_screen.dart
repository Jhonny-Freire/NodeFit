import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/domain/body.dart';
import '../../../core/domain/load.dart';
import '../../../core/widgets/common.dart';
import '../data/body_repository.dart';
import '../data/photo_store.dart';
import 'body_format.dart';
import 'photo_capture_screen.dart';
import 'profile_sheet.dart';
import 'scale_scan_screen.dart';

/// Check-in do corpo: peso, fotos, medidas com fita e o que a balança de
/// bioimpedância mostrou. Tudo opcional; só o que for preenchido é salvo.
class CheckinScreen extends ConsumerStatefulWidget {
  const CheckinScreen({super.key, this.checkinId});

  /// Null = check-in novo.
  final String? checkinId;

  @override
  ConsumerState<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends ConsumerState<CheckinScreen> {
  final _fields = {
    for (final m in BodyMetric.values)
      if (m.typed) m: TextEditingController(),
  };
  final _notes = TextEditingController();
  DateTime _takenAt = DateTime.now();

  /// Último valor de cada medida (dica "última: 85,5").
  Map<BodyMetric, int> _last = const {};

  /// Fotos já no banco (edição) e as tiradas agora (ainda não salvas).
  final Map<PhotoPose, String> _savedPhotos = {};
  final Map<PhotoPose, String> _newPhotos = {};

  /// Impedância lida pela balança (× 1000), guardada junto do peso.
  int? _impedanceMilli;
  bool _loading = true;
  bool _saving = false;
  bool _scaleOpen = false;

  BodyRepository get _repo => ref.read(bodyRepositoryProvider);

  @override
  void initState() {
    super.initState();
    _load();
    for (final c in _fields.values) {
      c.addListener(_refresh);
    }
  }

  void _refresh() => setState(() {});

  Future<void> _load() async {
    final id = widget.checkinId;
    _last = await _repo.lastValues(excludeCheckinId: id);
    if (id != null) {
      final c = await _repo.getCheckin(id);
      if (c != null) {
        _takenAt = c.checkin.takenAt.toLocal();
        _notes.text = c.checkin.notes ?? '';
        for (final e in c.values.entries) {
          _fields[e.key]?.text = formatNumber(e.value / 1000);
        }
        _impedanceMilli = c.values[BodyMetric.impedance];
        for (final p in c.photos) {
          _savedPhotos[p.pose] = p.path;
        }
      }
    }
    // A balança abre sozinha se você já usou (ou está editando com ela).
    _scaleOpen = BodyMetric.values.any(
      (m) =>
          m.group == BodyMetricGroup.scale &&
          (_last.containsKey(m) || (_fields[m]?.text.isNotEmpty ?? false)),
    );
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in _fields.values) {
      c.dispose();
    }
    _notes.dispose();
    super.dispose();
  }

  Map<BodyMetric, int> _values() => {
    for (final e in _fields.entries) e.key: ?parseLoadMilli(e.value.text),
    BodyMetric.impedance: ?_impedanceMilli,
  };

  Future<void> _readScale() async {
    final r = await readFromScale(context);
    if (r == null || !mounted) return;
    setState(() {
      _fields[BodyMetric.weight]!.text = formatNumber(
        double.parse(r.weightKg.toStringAsFixed(2)),
      );
      final imp = r.impedanceOhm;
      _impedanceMilli = imp == null || imp <= 0 ? null : (imp * 1000).round();
    });
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _takenAt,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );
    if (d == null) return;
    setState(
      () => _takenAt = DateTime(
        d.year,
        d.month,
        d.day,
        _takenAt.hour,
        _takenAt.minute,
      ),
    );
  }

  Future<void> _photo(PhotoPose pose) async {
    final previous = await _repo.previousPhoto(
      pose,
      before: widget.checkinId == null ? null : _takenAt.toUtc(),
    );
    final guide = previous == null
        ? null
        : await PhotoStore.resolve(previous.path);
    if (!mounted) return;
    final rel = await capturePosePhoto(
      context,
      pose: pose,
      guide: guide != null && guide.existsSync() ? guide : null,
    );
    if (rel == null) return;
    // Trocou a foto nova antes de salvar: a de antes vai embora.
    final replaced = _newPhotos[pose];
    if (replaced != null) await PhotoStore.delete([replaced]);
    setState(() => _newPhotos[pose] = rel);
  }

  Future<void> _save() async {
    if (_saving) return;
    final values = _values();
    if (values.isEmpty && _newPhotos.isEmpty && _savedPhotos.isEmpty) {
      showSnack(context, 'Preencha pelo menos uma medida ou tire uma foto.');
      return;
    }
    setState(() => _saving = true);
    final hasScale = values.keys.any((m) => m.group == BodyMetricGroup.scale);
    final id = await _repo.saveCheckin(
      id: widget.checkinId,
      takenAt: _takenAt.toUtc(),
      values: values,
      notes: _notes.text,
      source: hasScale ? BodySource.scale : BodySource.manual,
    );
    final old = <String>[];
    for (final e in _newPhotos.entries) {
      final replaced = await _repo.setPhoto(
        checkinId: id,
        pose: e.key,
        path: e.value,
      );
      if (replaced != null) old.add(replaced);
    }
    _newPhotos.clear();
    await PhotoStore.delete(old);
    await HapticFeedback.mediumImpact();
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final ok = await showConfirmDialog(
      context,
      title: 'Apagar este check-in?',
      message: 'As medidas e as fotos deste dia somem.',
      confirmLabel: 'Apagar',
      destructive: true,
    );
    if (!ok) return;
    final paths = await _repo.deleteCheckin(widget.checkinId!);
    await PhotoStore.delete([...paths, ..._newPhotos.values]);
    _newPhotos.clear();
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(bodyProfileProvider).value;
    return PopScope(
      // Saiu sem salvar: as fotos tiradas agora não ficam órfãs.
      onPopInvokedWithResult: (didPop, _) {
        if (didPop && _newPhotos.isNotEmpty) {
          PhotoStore.delete(_newPhotos.values.toList());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.checkinId == null ? 'Check-in' : 'Editar check-in',
          ),
          actions: [
            if (widget.checkinId != null)
              IconButton(
                tooltip: 'Apagar check-in',
                icon: const Icon(Icons.delete_outline),
                onPressed: _delete,
              ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton(
            onPressed: _loading || _saving ? null : _save,
            style: FilledButton.styleFrom(minimumSize: const Size(64, 56)),
            child: const Text('SALVAR'),
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.event, size: 18),
                    label: Text(
                      DateFormat("EEEE, d 'de' MMMM").format(_takenAt),
                    ),
                    onPressed: _pickDate,
                  ),
                  const SizedBox(height: 8),
                  _metricField(BodyMetric.weight, big: true),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _readScale,
                      icon: const Icon(Icons.bluetooth_searching),
                      label: Text(
                        _impedanceMilli == null
                            ? 'Ler da balança (Bluetooth)'
                            : 'Lido da balança · impedância '
                                  '${formatNumber((_impedanceMilli! / 1000).round())} Ω',
                      ),
                    ),
                  ),
                  _EstimateCard(
                    profile: profile,
                    values: {..._last, ..._values()},
                  ),
                  // Fotos usam a câmera e arquivos do celular: só no app
                  // Android (na versão web a seção some).
                  if (!kIsWeb) ...[
                    const SectionLabel('Fotos'),
                    Row(
                      children: [
                        for (final pose in PhotoPose.values)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: _PhotoSlot(
                                pose: pose,
                                path: _newPhotos[pose] ?? _savedPhotos[pose],
                                onTap: () => _photo(pose),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Ficam só no app (fora da Galeria) e vão no backup. A '
                        'foto anterior aparece em transparência para repetir a '
                        'pose.',
                        style: context.texts.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                  SectionLabel(BodyMetricGroup.tape.label),
                  for (final m in BodyMetric.values)
                    if (m.group == BodyMetricGroup.tape) _metricField(m),
                  const SizedBox(height: 8),
                  Card(
                    child: ExpansionTile(
                      initiallyExpanded: _scaleOpen,
                      shape: const Border(),
                      leading: const Icon(Icons.monitor_weight_outlined),
                      title: Text(BodyMetricGroup.scale.label),
                      subtitle: const Text(
                        'Copie o que a balança mostrou (ex.: app OKOK)',
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      children: [
                        for (final m in BodyMetric.values)
                          if (m.group == BodyMetricGroup.scale && m.typed)
                            _metricField(m),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notes,
                    maxLength: 300,
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Observação (opcional)',
                      hintText: 'Ex.: de manhã, em jejum',
                    ),
                  ),
                  if (profile != null && !profile.complete)
                    TextButton.icon(
                      onPressed: () => showProfileSheet(context),
                      icon: const Icon(Icons.person_outline),
                      label: const Text(
                        'Informe sexo e altura para ver IMC e % de gordura',
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Widget _metricField(BodyMetric m, {bool big = false}) {
    final last = _last[m];
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextField(
        controller: _fields[m],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        style: big
            ? context.texts.headlineSmall?.copyWith(fontWeight: FontWeight.w700)
            : null,
        decoration: InputDecoration(
          labelText: m.label,
          suffixText: m.unit,
          helperText: last == null
              ? null
              : 'última: ${formatMetric(m, last / 1000)}',
        ),
      ),
    );
  }
}

/// IMC e % de gordura estimados ao vivo, enquanto digita.
class _EstimateCard extends StatelessWidget {
  const _EstimateCard({required this.profile, required this.values});
  final BodyProfile? profile;
  final Map<BodyMetric, int> values;

  @override
  Widget build(BuildContext context) {
    final p = profile;
    if (p == null || !p.complete) return const SizedBox.shrink();
    double? v(BodyMetric m) => values[m] == null ? null : values[m]! / 1000;
    final imc = bmi(weightKg: v(BodyMetric.weight), heightCm: p.heightCm);
    final navy = navyBodyFat(
      sex: p.sex!,
      heightCm: p.heightCm!,
      neckCm: v(BodyMetric.neck),
      abdomenCm: v(BodyMetric.abdomen),
      waistCm: v(BodyMetric.waist),
      hipCm: v(BodyMetric.hip),
    );
    final lines = [
      if (imc != null)
        'IMC ${formatNumber(double.parse(imc.toStringAsFixed(1)))}',
      if (navy != null)
        'Gordura (fita, Marinha): ${formatNumber(double.parse(navy.toStringAsFixed(1)))}% ±4',
    ];
    if (lines.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        lines.join('  ·  '),
        style: context.texts.bodyMedium?.copyWith(
          color: context.colors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  const _PhotoSlot({
    required this.pose,
    required this.path,
    required this.onTap,
  });
  final PhotoPose pose;
  final String? path;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 3 / 4,
    child: Material(
      color: context.colors.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (path != null) BodyPhotoImage(path: path!),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      path == null ? Icons.add_a_photo_outlined : Icons.refresh,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      pose.label,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Foto da pasta privada a partir do caminho relativo.
class BodyPhotoImage extends StatefulWidget {
  const BodyPhotoImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
  });
  final String path;
  final BoxFit fit;

  @override
  State<BodyPhotoImage> createState() => _BodyPhotoImageState();
}

class _BodyPhotoImageState extends State<BodyPhotoImage> {
  // Guardado: redesenhar não relê o disco (nem pisca).
  late Future<File> _file = PhotoStore.resolve(widget.path);

  @override
  void didUpdateWidget(covariant BodyPhotoImage old) {
    super.didUpdateWidget(old);
    if (old.path != widget.path) _file = PhotoStore.resolve(widget.path);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<File>(
    future: _file,
    builder: (context, snap) {
      final f = snap.data;
      if (f == null || !f.existsSync()) return const SizedBox.shrink();
      return Image.file(f, fit: widget.fit, cacheWidth: 600);
    },
  );
}
