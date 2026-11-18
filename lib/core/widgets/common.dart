import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_theme.dart';

/// Mostra carregando / erro / conteúdo de um AsyncValue.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({super.key, required this.value, required this.builder});
  final AsyncValue<T> value;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) => switch (value) {
    AsyncData(:final value) => builder(value),
    AsyncError(:final error) => Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Algo deu errado:\n$error',
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.error),
        ),
      ),
    ),
    _ => const Center(child: CircularProgressIndicator()),
  };
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
  });
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: context.colors.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(
            title,
            style: context.texts.titleMedium,
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              style: context.texts.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[const SizedBox(height: 20), action!],
        ],
      ),
    ),
  );
}

/// Título de seção ("AJUSTES", "SÉRIES").
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text.toUpperCase(),
            style: context.texts.labelMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

/// Espaço embaixo de uma folha: o teclado, se aberto; senão a barra de
/// navegação do Android. Mais [extra].
double sheetBottomPadding(BuildContext context, [double extra = 16]) {
  final keyboard = MediaQuery.viewInsetsOf(context).bottom;
  final systemBar = MediaQuery.viewPaddingOf(context).bottom;
  return (keyboard > systemBar ? keyboard : systemBar) + extra;
}

/// Pede um texto. Retorna null se cancelar.
Future<String?> showTextInputDialog(
  BuildContext context, {
  required String title,
  String? initial,
  String? hint,
  String confirmLabel = 'Salvar',
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  bool allowEmpty = false,
  int? maxLength,
}) => showDialog<String>(
  context: context,
  builder: (_) => _InputDialog(
    title: title,
    initial: initial ?? '',
    hint: hint,
    confirmLabel: confirmLabel,
    keyboardType: keyboardType,
    maxLines: maxLines,
    allowEmpty: allowEmpty,
    maxLength: maxLength,
  ),
);

/// Pede um número decimal (aceita vírgula ou ponto).
Future<String?> showNumberInputDialog(
  BuildContext context, {
  required String title,
  String? initial,
  String? suffix,
}) => showDialog<String>(
  context: context,
  builder: (_) => _InputDialog(
    title: title,
    initial: initial ?? '',
    suffix: suffix,
    confirmLabel: 'OK',
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    allowEmpty: true,
    numeric: true,
  ),
);

/// O diálogo é dono do controlador e só o descarta quando sai de vez da
/// tela. (Descartar ao fechar — enquanto o diálogo ainda anima a saída —
/// derrubava o app no S26.)
class _InputDialog extends StatefulWidget {
  const _InputDialog({
    required this.title,
    required this.initial,
    required this.confirmLabel,
    required this.keyboardType,
    this.hint,
    this.suffix,
    this.maxLines = 1,
    this.allowEmpty = false,
    this.maxLength,
    this.numeric = false,
  });
  final String title;
  final String initial;
  final String? hint;
  final String? suffix;
  final String confirmLabel;
  final TextInputType keyboardType;
  final int maxLines;
  final bool allowEmpty;
  final int? maxLength;
  final bool numeric;

  @override
  State<_InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<_InputDialog> {
  late final _controller = TextEditingController(text: widget.initial)
    ..selection = widget.numeric
        ? TextSelection(baseOffset: 0, extentOffset: widget.initial.length)
        : TextSelection.collapsed(offset: widget.initial.length);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canConfirm =>
      widget.allowEmpty || _controller.text.trim().isNotEmpty;

  void _confirm() {
    if (_canConfirm) Navigator.of(context).pop(_controller.text);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: TextField(
      controller: _controller,
      autofocus: true,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: widget.numeric
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))]
          : null,
      style: widget.numeric
          ? context.texts.headlineSmall?.copyWith(fontFeatures: tabularFigures)
          : null,
      decoration: InputDecoration(
        hintText: widget.hint,
        suffixText: widget.suffix,
      ),
      onChanged: (_) => setState(() {}),
      onSubmitted: widget.maxLines == 1 ? (_) => _confirm() : null,
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
      TextButton(
        onPressed: _canConfirm ? _confirm : null,
        child: Text(widget.confirmLabel),
      ),
    ],
  );
}

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  String confirmLabel = 'Confirmar',
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: message == null ? null : Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          style: destructive
              ? TextButton.styleFrom(foregroundColor: context.colors.error)
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

void showSnack(
  BuildContext context,
  String message, {
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 4),
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        // Com ação, o padrão do Flutter 3.47 é ficar até tocar: aqui o
        // "Desfazer" precisa sumir sozinho.
        persist: false,
        action: actionLabel == null
            ? null
            : SnackBarAction(label: actionLabel, onPressed: onAction ?? () {}),
      ),
    );
}
