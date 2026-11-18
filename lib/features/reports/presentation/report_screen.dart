import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/domain/reports.dart';
import '../../../core/widgets/common.dart';
import '../data/report_repository.dart';

/// Prévia do relatório (rota `/mais/relatorio/:tipo`): o aluno escolhe o
/// período, vê exatamente o texto que vai sair e só então compartilha.
class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key, required this.audience});
  final ReportAudience audience;

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  late int _weeks = widget.audience.defaultWeeks;

  /// O que vai (e o que não vai) em cada relatório — ver docs/PERSONAS.md.
  String get _scope => switch (widget.audience) {
    ReportAudience.trainer =>
      'Vai: constância, fichas, evolução de carga, dores e "como foi". '
          'Não vai: peso, medidas nem fotos.',
    ReportAudience.doctor =>
      'Vai: minutos de treino por semana, peso, IMC, cintura, gordura e '
          'dores. Não vai: cargas, ajustes de aparelho nem fotos.',
  };

  Future<void> _share(String text) async {
    await SharePlus.instance.share(
      ShareParams(text: text, subject: 'NodeFit — ${widget.audience.title}'),
    );
  }

  Future<void> _copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) showSnack(context, 'Relatório copiado.');
  }

  @override
  Widget build(BuildContext context) {
    final report = ref.watch(reportTextProvider(widget.audience, _weeks));
    final text = report.value;

    return Scaffold(
      appBar: AppBar(title: Text(widget.audience.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            _scope,
            style: context.texts.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 4, label: Text('1 mês')),
              ButtonSegment(value: 8, label: Text('2 meses')),
              ButtonSegment(value: 12, label: Text('3 meses')),
            ],
            selected: {_weeks},
            onSelectionChanged: (s) => setState(() => _weeks = s.first),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: switch (report) {
                AsyncError(:final error) => Text(
                  'Não consegui montar o relatório: $error',
                ),
                _ when text == null => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                ),
                _ => SelectableText(
                  text,
                  style: context.texts.bodyMedium?.copyWith(height: 1.4),
                ),
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: text == null ? null : () => _copy(text),
                  icon: const Icon(Icons.copy),
                  label: const Text('Copiar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: text == null ? null : () => _share(text),
                  icon: const Icon(Icons.ios_share),
                  label: const Text('Compartilhar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
