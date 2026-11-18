import 'dart:async';

import 'package:flutter/material.dart';

/// "32:14" ou "1:05:09" desde [since], atualizando a cada segundo.
class ElapsedText extends StatefulWidget {
  const ElapsedText({super.key, required this.since, this.style});
  final DateTime since;
  final TextStyle? style;

  @override
  State<ElapsedText> createState() => _ElapsedTextState();
}

class _ElapsedTextState extends State<ElapsedText> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(
    formatDuration(DateTime.now().difference(widget.since)),
    style: widget.style,
  );
}

/// 75 s → "1:15"; 3725 s → "1:02:05".
String formatDuration(Duration d) {
  final total = d.inSeconds < 0 ? 0 : d.inSeconds;
  final h = total ~/ 3600;
  final m = (total % 3600) ~/ 60;
  final s = total % 60;
  final ss = s.toString().padLeft(2, '0');
  if (h > 0) return '$h:${m.toString().padLeft(2, '0')}:$ss';
  return '$m:$ss';
}
