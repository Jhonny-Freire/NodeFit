// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin_reminder.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// O lembrete atual (null = desligado).

@ProviderFor(checkinReminder)
final checkinReminderProvider = CheckinReminderProvider._();

/// O lembrete atual (null = desligado).

final class CheckinReminderProvider
    extends
        $FunctionalProvider<
          AsyncValue<CheckinReminder?>,
          CheckinReminder?,
          Stream<CheckinReminder?>
        >
    with $FutureModifier<CheckinReminder?>, $StreamProvider<CheckinReminder?> {
  /// O lembrete atual (null = desligado).
  CheckinReminderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkinReminderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkinReminderHash();

  @$internal
  @override
  $StreamProviderElement<CheckinReminder?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<CheckinReminder?> create(Ref ref) {
    return checkinReminder(ref);
  }
}

String _$checkinReminderHash() => r'592a88ea375cd4b8bb69b61d63483fe6f70c3a11';
