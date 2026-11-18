// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gymRepository)
final gymRepositoryProvider = GymRepositoryProvider._();

final class GymRepositoryProvider
    extends $FunctionalProvider<GymRepository, GymRepository, GymRepository>
    with $Provider<GymRepository> {
  GymRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gymRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gymRepositoryHash();

  @$internal
  @override
  $ProviderElement<GymRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GymRepository create(Ref ref) {
    return gymRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GymRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GymRepository>(value),
    );
  }
}

String _$gymRepositoryHash() => r'666a8f78dbc48b5b339dc0e1f9453f745858045a';

@ProviderFor(gyms)
final gymsProvider = GymsProvider._();

final class GymsProvider
    extends
        $FunctionalProvider<AsyncValue<List<Gym>>, List<Gym>, Stream<List<Gym>>>
    with $FutureModifier<List<Gym>>, $StreamProvider<List<Gym>> {
  GymsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gymsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gymsHash();

  @$internal
  @override
  $StreamProviderElement<List<Gym>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Gym>> create(Ref ref) {
    return gyms(ref);
  }
}

String _$gymsHash() => r'fd693fe7b52c72427865cc5a582f5085aad0ab11';

/// Academia atual: a escolhida nas preferências ou, se não houver, a
/// primeira da lista. Null quando ainda não existe nenhuma academia.

@ProviderFor(currentGym)
final currentGymProvider = CurrentGymProvider._();

/// Academia atual: a escolhida nas preferências ou, se não houver, a
/// primeira da lista. Null quando ainda não existe nenhuma academia.

final class CurrentGymProvider
    extends $FunctionalProvider<AsyncValue<Gym?>, Gym?, Stream<Gym?>>
    with $FutureModifier<Gym?>, $StreamProvider<Gym?> {
  /// Academia atual: a escolhida nas preferências ou, se não houver, a
  /// primeira da lista. Null quando ainda não existe nenhuma academia.
  CurrentGymProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentGymProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentGymHash();

  @$internal
  @override
  $StreamProviderElement<Gym?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Gym?> create(Ref ref) {
    return currentGym(ref);
  }
}

String _$currentGymHash() => r'c41844cb4260b6014b54f159fbefbe0a06abc83b';

@ProviderFor(gymEquipment)
final gymEquipmentProvider = GymEquipmentFamily._();

final class GymEquipmentProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EquipmentItem>>,
          List<EquipmentItem>,
          Stream<List<EquipmentItem>>
        >
    with
        $FutureModifier<List<EquipmentItem>>,
        $StreamProvider<List<EquipmentItem>> {
  GymEquipmentProvider._({
    required GymEquipmentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'gymEquipmentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gymEquipmentHash();

  @override
  String toString() {
    return r'gymEquipmentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<EquipmentItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<EquipmentItem>> create(Ref ref) {
    final argument = this.argument as String;
    return gymEquipment(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GymEquipmentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gymEquipmentHash() => r'57c079559da283082e019e8861af523c052312b3';

final class GymEquipmentFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<EquipmentItem>>, String> {
  GymEquipmentFamily._()
    : super(
        retry: null,
        name: r'gymEquipmentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GymEquipmentProvider call(String gymId) =>
      GymEquipmentProvider._(argument: gymId, from: this);

  @override
  String toString() => r'gymEquipmentProvider';
}

@ProviderFor(equipmentItem)
final equipmentItemProvider = EquipmentItemFamily._();

final class EquipmentItemProvider
    extends
        $FunctionalProvider<
          AsyncValue<EquipmentItem?>,
          EquipmentItem?,
          Stream<EquipmentItem?>
        >
    with $FutureModifier<EquipmentItem?>, $StreamProvider<EquipmentItem?> {
  EquipmentItemProvider._({
    required EquipmentItemFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'equipmentItemProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$equipmentItemHash();

  @override
  String toString() {
    return r'equipmentItemProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<EquipmentItem?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<EquipmentItem?> create(Ref ref) {
    final argument = this.argument as String;
    return equipmentItem(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EquipmentItemProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$equipmentItemHash() => r'3093efb81729178077fc74fcf667a247ce576346';

final class EquipmentItemFamily extends $Family
    with $FunctionalFamilyOverride<Stream<EquipmentItem?>, String> {
  EquipmentItemFamily._()
    : super(
        retry: null,
        name: r'equipmentItemProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EquipmentItemProvider call(String id) =>
      EquipmentItemProvider._(argument: id, from: this);

  @override
  String toString() => r'equipmentItemProvider';
}
