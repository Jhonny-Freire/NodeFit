import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import 'elapsed_text.dart';

/// Descanso em contagem regressiva. A fonte da verdade é [endsAt] (salvo no
/// banco): o widget só calcula `restante = endsAt − agora`, então nada se
/// perde se o app fechar. O alerta (vibração + som) é disparado por
/// RestAlertListener, na raiz do app; a notificação na tela bloqueada vem na
/// Fatia 2.
class RestBar extends StatefulWidget {
  const RestBar({
    super.key,
    required this.endsAt,
    required this.onAdjust,
    required this.onSkip,
  });

  final DateTime endsAt;
  final ValueChanged<int> onAdjust;
  final VoidCallback onSkip;

  @override
  State<RestBar> createState() => _RestBarState();
}

class _RestBarState extends State<RestBar> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.endsAt.difference(DateTime.now());
    final done = remaining <= Duration.zero;
    final rest = context.semantic.rest;
    return Container(
      color: rest.withValues(alpha: 0.14),
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: [
          Icon(done ? Icons.alarm_on : Icons.hourglass_bottom, color: rest),
          const SizedBox(width: 8),
          Text(
            done ? 'Bora!' : 'Descanso',
            style: context.texts.labelLarge?.copyWith(color: rest),
          ),
          const SizedBox(width: 8),
          Expanded(
            // Encolhe em vez de quebrar o número (fonte grande, tela estreita).
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                done
                    ? '0:00'
                    : formatDuration(
                        remaining + const Duration(milliseconds: 999),
                      ),
                maxLines: 1,
                softWrap: false,
                style: context.texts.headlineSmall?.copyWith(
                  color: rest,
                  fontWeight: FontWeight.w700,
                  fontFeatures: tabularFigures,
                ),
              ),
            ),
          ),
          _SmallButton(label: '−15s', onTap: () => widget.onAdjust(-15)),
          _SmallButton(label: '+15s', onTap: () => widget.onAdjust(15)),
          _SmallButton(label: done ? 'OK' : 'Pular', onTap: widget.onSkip),
        ],
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4),
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(56, 48),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        foregroundColor: context.semantic.rest,
        side: BorderSide(color: context.semantic.rest.withValues(alpha: 0.5)),
      ),
      child: Text(label),
    ),
  );
}
