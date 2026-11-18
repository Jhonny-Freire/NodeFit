import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/domain/load.dart';
import '../../../core/domain/reports.dart';
import '../../../core/prefs/prefs_repository.dart';
import '../../../core/widgets/common.dart';
import '../../auth/data/auth_service.dart';
import '../../backup/backup_service.dart';
import '../../backup/csv_export.dart';
import '../../body/data/body_repository.dart';
import '../../body/presentation/checkin_reminder.dart';
import '../../body/presentation/profile_sheet.dart';
import '../../backup/restore_flow.dart';
import '../../workout/presentation/widgets/session_exercise_card.dart';

/// Versão mostrada em "Sobre" (a mesma do pubspec).
const appVersion = '0.6.0';

/// Aba Mais: conta (logout), backup, preferências e sobre.
class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {
  bool _exporting = false;

  Future<void> _export() async {
    setState(() => _exporting = true);
    try {
      final ok = await ref.read(backupServiceProvider).exportAndShare();
      if (mounted && ok) showSnack(context, 'Backup gerado.');
    } catch (e) {
      if (mounted) showSnack(context, 'Não consegui gerar o backup: $e');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _exportCsv() async {
    setState(() => _exporting = true);
    try {
      final ok = await ref.read(csvExporterProvider).exportAndShare();
      if (mounted && ok) showSnack(context, 'Planilhas geradas.');
    } catch (e) {
      if (mounted) showSnack(context, 'Não consegui gerar as planilhas: $e');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  /// Logout com confirmação. Os dados ficam no celular; o roteador manda
  /// para a tela de login assim que a sessão some.
  Future<void> _logout() async {
    final ok = await showConfirmDialog(
      context,
      title: 'Sair da conta?',
      message:
          'Seus treinos continuam salvos neste celular. Para voltar, entre '
          'de novo com e-mail e senha.',
      confirmLabel: 'Sair',
    );
    if (ok) await ref.read(authServiceProvider).logout();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final lastBackup = ref.watch(lastBackupAtProvider).value;
    final rest =
        ref.watch(defaultRestSecProvider).value ?? defaultRestSecFallback;
    final keepOn = ref.watch(keepScreenOnProvider).value ?? true;
    final prefs = ref.read(prefsRepositoryProvider);
    final profile = ref.watch(bodyProfileProvider).value;
    final reminder = ref.watch(checkinReminderProvider).value;
    // Dias de calendário (UTC evita erro com horário de verão).
    final int? days;
    if (lastBackup == null) {
      days = null;
    } else {
      final l = lastBackup.toLocal();
      final n = DateTime.now();
      days = DateTime.utc(
        n.year,
        n.month,
        n.day,
      ).difference(DateTime.utc(l.year, l.month, l.day)).inDays;
    }
    final backupWarning = days == null || days >= 7;

    return Scaffold(
      appBar: AppBar(title: const Text('Mais')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionLabel('Conta'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  title: Text(user?.name ?? '—'),
                  subtitle: Text(user?.email ?? ''),
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: context.colors.error),
                  title: Text(
                    'Sair',
                    style: TextStyle(color: context.colors.error),
                  ),
                  onTap: _logout,
                ),
              ],
            ),
          ),
          // Relatórios para quem acompanha o aluno (docs/PERSONAS.md).
          const SectionLabel('Compartilhar'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.sports_outlined),
                  title: const Text('Relatório para o professor'),
                  subtitle: const Text(
                    'Constância, evolução de carga, dores e fichas',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go(
                    '/mais/relatorio/${ReportAudience.trainer.slug}',
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.medical_services_outlined),
                  title: const Text('Relatório para o médico'),
                  subtitle: const Text(
                    'Atividade por semana, peso, IMC, medidas e dores',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go(
                    '/mais/relatorio/${ReportAudience.doctor.slug}',
                  ),
                ),
              ],
            ),
          ),
          const SectionLabel('Backup'),
          // Backup e planilhas gravam arquivos no celular: só no app Android.
          if (kIsWeb)
            const Card(
              child: ListTile(
                leading: Icon(Icons.phone_android),
                title: Text('Backup só no app Android'),
                subtitle: Text(
                  'Na versão web os dados ficam guardados neste navegador.',
                ),
              ),
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(
                          backupWarning
                              ? Icons.warning_amber
                              : Icons.cloud_done,
                          color: backupWarning
                              ? context.semantic.attention
                              : context.colors.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            lastBackup == null
                                ? 'Você ainda não fez nenhum backup.'
                                : days == 0
                                ? 'Último backup: hoje.'
                                : 'Último backup: há $days dia(s).',
                            style: context.texts.titleSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Seus dados ficam só neste celular. O backup gera um '
                      'arquivo .zip com tudo — mande para o seu Drive, e-mail '
                      'ou PC. Para voltar, use "Restaurar". O app também guarda '
                      'sozinho uma cópia por dia (as 3 últimas).',
                      style: context.texts.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _exporting ? null : _export,
                      icon: const Icon(Icons.ios_share),
                      label: Text(_exporting ? 'Gerando…' : 'Exportar backup'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _exporting
                          ? null
                          : () => restoreFromBackupFlow(context, ref),
                      icon: const Icon(Icons.settings_backup_restore),
                      label: const Text('Restaurar backup'),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _exporting ? null : _exportCsv,
                      icon: const Icon(Icons.table_chart_outlined),
                      label: const Text('Exportar planilhas (Excel/CSV)'),
                    ),
                  ],
                ),
              ),
            ),
          const SectionLabel('Treino'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.timer_outlined),
                  title: const Text('Descanso padrão'),
                  subtitle: const Text('Para exercícios novos no treino'),
                  trailing: Text('$rest s', style: context.texts.titleMedium),
                  onTap: () async {
                    final s = await showRestPicker(context, current: rest);
                    if (s != null) {
                      await prefs.set(PrefKeys.defaultRestSec, '$s');
                    }
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.light_mode_outlined),
                  title: const Text('Manter a tela ligada no treino'),
                  value: keepOn,
                  onChanged: (v) => prefs.set(PrefKeys.keepScreenOn, '$v'),
                ),
              ],
            ),
          ),
          const SectionLabel('Corpo'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Perfil'),
                  subtitle: Text(
                    profile == null || !profile.complete
                        ? 'Sexo e altura (para IMC e % de gordura)'
                        : [
                            profile.sex!.label,
                            '${formatNumber(profile.heightCm!)} cm',
                            if (profile.birthYear != null)
                              'nasc. ${profile.birthYear}',
                          ].join(' · '),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showProfileSheet(context),
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Lembrete de check-in'),
                  subtitle: Text(reminderLabel(reminder)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => editCheckinReminder(context, ref, reminder),
                ),
              ],
            ),
          ),
          const SectionLabel('Sobre'),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('NodeFit $appVersion'),
                  subtitle: Text(
                    'Caderno digital de treino. Offline, conta local.',
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.health_and_safety_outlined),
                  title: Text('Não é orientação médica'),
                  subtitle: Text(
                    'Estimativas (como o 1RM) são aproximadas. Procure um '
                    'profissional de educação física ou de saúde.',
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Licenças de software'),
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: 'NodeFit',
                    applicationVersion: appVersion,
                    applicationLegalese:
                        'Catálogo de exercícios escrito à mão (PT-BR), sem '
                        'conteúdo de terceiros.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
