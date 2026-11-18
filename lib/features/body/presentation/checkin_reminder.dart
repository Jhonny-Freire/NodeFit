import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/platform/rest_notifications.dart';
import '../../../core/prefs/prefs_repository.dart';
import '../../../core/widgets/common.dart';
import '../data/body_repository.dart';

part 'checkin_reminder.g.dart';

/// Dia da semana (1 = segunda) e minutos desde a meia-noite.
typedef CheckinReminder = ({int weekday, int minutes});

const _weekdays = [
  'segunda',
  'terça',
  'quarta',
  'quinta',
  'sexta',
  'sábado',
  'domingo',
];

/// O lembrete atual (null = desligado).
@riverpod
Stream<CheckinReminder?> checkinReminder(Ref ref) {
  final prefs = ref.watch(prefsRepositoryProvider);
  return prefs.watch(BodyPrefKeys.reminderWeekday).asyncMap((day) async {
    final weekday = int.tryParse(day ?? '');
    final minutes = int.tryParse(
      await prefs.get(BodyPrefKeys.reminderMinutes) ?? '',
    );
    if (weekday == null || minutes == null) return null;
    return (weekday: weekday, minutes: minutes);
  });
}

String reminderLabel(CheckinReminder? r) {
  if (r == null) return 'Desligado';
  final h = (r.minutes ~/ 60).toString().padLeft(2, '0');
  final m = (r.minutes % 60).toString().padLeft(2, '0');
  return 'Toda ${_weekdays[r.weekday - 1]}, $h:$m';
}

/// Escolher dia e hora (ou desligar). Agenda/cancela na hora.
Future<void> editCheckinReminder(
  BuildContext context,
  WidgetRef ref,
  CheckinReminder? current,
) async {
  final weekday = await showDialog<int>(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('Lembrete de check-in'),
      children: [
        for (var d = 1; d <= 7; d++)
          SimpleDialogOption(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            onPressed: () => Navigator.of(context).pop(d),
            child: Row(
              children: [
                Expanded(child: Text('Toda ${_weekdays[d - 1]}')),
                if (current?.weekday == d) const Icon(Icons.check),
              ],
            ),
          ),
        const Divider(),
        SimpleDialogOption(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          onPressed: () => Navigator.of(context).pop(0),
          child: const Text('Desligar'),
        ),
      ],
    ),
  );
  if (weekday == null || !context.mounted) return;
  final prefs = ref.read(prefsRepositoryProvider);
  final notifications = RestNotifications.instance;
  if (weekday == 0) {
    await prefs.set(BodyPrefKeys.reminderMinutes, null);
    await prefs.set(BodyPrefKeys.reminderWeekday, null);
    await notifications.cancelWeeklyCheckin();
    return;
  }
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(
      hour: (current?.minutes ?? 7 * 60) ~/ 60,
      minute: (current?.minutes ?? 0) % 60,
    ),
    helpText: 'Horário do lembrete',
  );
  if (time == null || !context.mounted) return;
  final minutes = time.hour * 60 + time.minute;
  final ok = await notifications.scheduleWeeklyCheckin(
    weekday: weekday,
    minutes: minutes,
  );
  // Minutos antes do dia: quem observa o dia já encontra a hora certa.
  await prefs.set(BodyPrefKeys.reminderMinutes, '$minutes');
  await prefs.set(BodyPrefKeys.reminderWeekday, '$weekday');
  if (!ok && context.mounted) {
    showSnack(
      context,
      'Sem permissão de notificação: libere em Configurações → Apps → '
      'NodeFit.',
    );
  }
}
