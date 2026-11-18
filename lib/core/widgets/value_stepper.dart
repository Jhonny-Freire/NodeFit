import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_theme.dart';

/// [−] valor [+] para a zona do polegar: alvos de 56 dp, passo do aparelho,
/// segurar acelera, tocar no valor permite digitar.
class ValueStepper extends StatefulWidget {
  const ValueStepper({
    super.key,
    required this.label,
    required this.value,
    required this.step,
    required this.format,
    required this.onChanged,
    this.onTapValue,
    this.min = 0,
    this.max = 9999000,
    this.decreaseTooltip = 'Diminuir',
    this.increaseTooltip = 'Aumentar',
  });

  final String label;

  /// Valor atual (null = vazio; o primeiro [+] começa do zero).
  final int? value;
  final int step;
  final String Function(int? value) format;
  final ValueChanged<int> onChanged;

  /// Toque no número: abre a digitação (valores fora do passo).
  final VoidCallback? onTapValue;
  final int min;
  final int max;
  final String decreaseTooltip;
  final String increaseTooltip;

  @override
  State<ValueStepper> createState() => _ValueStepperState();
}

class _ValueStepperState extends State<ValueStepper> {
  Timer? _repeat;
  int? _current;

  @override
  void didUpdateWidget(covariant ValueStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_repeat == null) _current = widget.value;
  }

  @override
  void initState() {
    super.initState();
    _current = widget.value;
  }

  @override
  void dispose() {
    _repeat?.cancel();
    super.dispose();
  }

  void _bump(int direction) {
    // Vazio (primeira vez): em vez de subir do zero de passo em passo,
    // abre a digitação.
    if ((_current ?? widget.value) == null && widget.onTapValue != null) {
      _stopRepeat();
      widget.onTapValue!();
      return;
    }
    final base = _current ?? widget.value ?? 0;
    final next = (base + direction * widget.step).clamp(widget.min, widget.max);
    if (next == _current && widget.value != null) return;
    HapticFeedback.selectionClick();
    setState(() => _current = next);
    widget.onChanged(next);
  }

  void _startRepeat(int direction) {
    _repeat?.cancel();
    _repeat = Timer.periodic(
      const Duration(milliseconds: 120),
      (_) => _bump(direction),
    );
  }

  void _stopRepeat() {
    _repeat?.cancel();
    _repeat = null;
  }

  Widget _button(IconData icon, int direction, String tooltip) => Tooltip(
    message: tooltip,
    child: GestureDetector(
      onLongPressStart: (_) => _startRepeat(direction),
      onLongPressEnd: (_) => _stopRepeat(),
      onLongPressCancel: _stopRepeat,
      child: IconButton.filledTonal(
        onPressed: () => _bump(direction),
        icon: Icon(icon),
        iconSize: 28,
        style: IconButton.styleFrom(
          minimumSize: const Size(56, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
          textAlign: TextAlign.center,
          style: context.texts.labelMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            _button(Icons.remove, -1, widget.decreaseTooltip),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: widget.onTapValue,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child:
                        (_current ?? widget.value) == null &&
                            widget.onTapValue != null
                        ? Text(
                            'digitar',
                            style: context.texts.titleMedium?.copyWith(
                              color: context.colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : Text(
                            widget.format(_current ?? widget.value),
                            style: context.texts.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontFeatures: tabularFigures,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            _button(Icons.add, 1, widget.increaseTooltip),
          ],
        ),
      ],
    );
  }
}
