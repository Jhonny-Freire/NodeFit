// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stationRepository)
final stationRepositoryProvider = StationRepositoryProvider._();

final class StationRepositoryProvider
    extends
        $FunctionalProvider<
          StationRepository,
          StationRepository,
          StationRepository
        >
    with $Provider<StationRepository> {
  StationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stationRepositoryHash();

  @$internal
  @override
  $ProviderElement<StationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StationRepository create(Ref ref) {
    return stationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StationRepository>(value),
    );
  }
}

String _$stationRepositoryHash() => r'a6f226fd36c66b77753ea02471eb98e050703a29';

@ProviderFor(stationView)
final stationViewProvider = StationViewFamily._();

final class StationViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<StationView?>,
          StationView?,
          Stream<StationView?>
        >
    with $FutureModifier<StationView?>, $StreamProvider<StationView?> {
  StationViewProvider._({
    required StationViewFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stationViewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stationViewHash();

  @override
  String toString() {
    return r'stationViewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<StationView?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<StationView?> create(Ref ref) {
    final argument = this.argument as String;
    return stationView(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StationViewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stationViewHash() => r'2cc99fed584e92de318139314049b87e004fa42b';

final class StationViewFamily extends $Family
    with $FunctionalFamilyOverride<Stream<StationView?>, String> {
  StationViewFamily._()
    : super(
        retry: null,
        name: r'stationViewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StationViewProvider call(String stationId) =>
      StationViewProvider._(argument: stationId, from: this);

  @override
  String toString() => r'stationViewProvider';
}

@ProviderFor(equipmentStations)
final equipmentStationsProvider = EquipmentStationsFamily._();

final class EquipmentStationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StationView>>,
          List<StationView>,
          Stream<List<StationView>>
        >
    with
        $FutureModifier<List<StationView>>,
        $StreamProvider<List<StationView>> {
  EquipmentStationsProvider._({
    required EquipmentStationsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'equipmentStationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$equipmentStationsHash();

  @override
  String toString() {
    return r'equipmentStationsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<StationView>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<StationView>> create(Ref ref) {
    final argument = this.argument as String;
    return equipmentStations(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EquipmentStationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$equipmentStationsHash() => r'dc94c92247a36537fda02774f0156a1d973b11d5';

final class EquipmentStationsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<StationView>>, String> {
  EquipmentStationsFamily._()
    : super(
        retry: null,
        name: r'equipmentStationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EquipmentStationsProvider call(String equipmentId) =>
      EquipmentStationsProvider._(argument: equipmentId, from: this);

  @override
  String toString() => r'equipmentStationsProvider';
}

@ProviderFor(gymStationsWithoutEquipment)
final gymStationsWithoutEquipmentProvider =
    GymStationsWithoutEquipmentFamily._();

final class GymStationsWithoutEquipmentProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StationView>>,
          List<StationView>,
          Stream<List<StationView>>
        >
    with
        $FutureModifier<List<StationView>>,
        $StreamProvider<List<StationView>> {
  GymStationsWithoutEquipmentProvider._({
    required GymStationsWithoutEquipmentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'gymStationsWithoutEquipmentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gymStationsWithoutEquipmentHash();

  @override
  String toString() {
    return r'gymStationsWithoutEquipmentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<StationView>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<StationView>> create(Ref ref) {
    final argument = this.argument as String;
    return gymStationsWithoutEquipment(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GymStationsWithoutEquipmentProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gymStationsWithoutEquipmentHash() =>
    r'55f2cb729bc5162d664f92ed4bcc28a71a57e776';

final class GymStationsWithoutEquipmentFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<StationView>>, String> {
  GymStationsWithoutEquipmentFamily._()
    : super(
        retry: null,
        name: r'gymStationsWithoutEquipmentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GymStationsWithoutEquipmentProvider call(String gymId) =>
      GymStationsWithoutEquipmentProvider._(argument: gymId, from: this);

  @override
  String toString() => r'gymStationsWithoutEquipmentProvider';
}

@ProviderFor(stationSettings)
final stationSettingsProvider = StationSettingsFamily._();

final class StationSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StationSetting>>,
          List<StationSetting>,
          Stream<List<StationSetting>>
        >
    with
        $FutureModifier<List<StationSetting>>,
        $StreamProvider<List<StationSetting>> {
  StationSettingsProvider._({
    required StationSettingsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stationSettingsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stationSettingsHash();

  @override
  String toString() {
    return r'stationSettingsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<StationSetting>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<StationSetting>> create(Ref ref) {
    final argument = this.argument as String;
    return stationSettings(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StationSettingsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stationSettingsHash() => r'e47ce06c9cfc0b9088ba0a7ee795a73401eec015';

final class StationSettingsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<StationSetting>>, String> {
  StationSettingsFamily._()
    : super(
        retry: null,
        name: r'stationSettingsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StationSettingsProvider call(String stationId) =>
      StationSettingsProvider._(argument: stationId, from: this);

  @override
  String toString() => r'stationSettingsProvider';
}

@ProviderFor(stationChanges)
final stationChangesProvider = StationChangesFamily._();

final class StationChangesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SettingChangeView>>,
          List<SettingChangeView>,
          Stream<List<SettingChangeView>>
        >
    with
        $FutureModifier<List<SettingChangeView>>,
        $StreamProvider<List<SettingChangeView>> {
  StationChangesProvider._({
    required StationChangesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stationChangesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stationChangesHash();

  @override
  String toString() {
    return r'stationChangesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<SettingChangeView>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SettingChangeView>> create(Ref ref) {
    final argument = this.argument as String;
    return stationChanges(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StationChangesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stationChangesHash() => r'2908c8f01cbbbbf668511680f73e81dac4e43dd0';

final class StationChangesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<SettingChangeView>>, String> {
  StationChangesFamily._()
    : super(
        retry: null,
        name: r'stationChangesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StationChangesProvider call(String stationId) =>
      StationChangesProvider._(argument: stationId, from: this);

  @override
  String toString() => r'stationChangesProvider';
}
