// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(routineRepository)
final routineRepositoryProvider = RoutineRepositoryProvider._();

final class RoutineRepositoryProvider
    extends
        $FunctionalProvider<
          RoutineRepository,
          RoutineRepository,
          RoutineRepository
        >
    with $Provider<RoutineRepository> {
  RoutineRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routineRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routineRepositoryHash();

  @$internal
  @override
  $ProviderElement<RoutineRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RoutineRepository create(Ref ref) {
    return routineRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoutineRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoutineRepository>(value),
    );
  }
}

String _$routineRepositoryHash() => r'f42bf505e18846058ee45b9a93c6964ff05cc6f3';

@ProviderFor(gymRoutines)
final gymRoutinesProvider = GymRoutinesFamily._();

final class GymRoutinesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RoutineSummary>>,
          List<RoutineSummary>,
          Stream<List<RoutineSummary>>
        >
    with
        $FutureModifier<List<RoutineSummary>>,
        $StreamProvider<List<RoutineSummary>> {
  GymRoutinesProvider._({
    required GymRoutinesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'gymRoutinesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gymRoutinesHash();

  @override
  String toString() {
    return r'gymRoutinesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<RoutineSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RoutineSummary>> create(Ref ref) {
    final argument = this.argument as String;
    return gymRoutines(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GymRoutinesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gymRoutinesHash() => r'308c7bdf4f221488481ec240352628e2ae324b86';

final class GymRoutinesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<RoutineSummary>>, String> {
  GymRoutinesFamily._()
    : super(
        retry: null,
        name: r'gymRoutinesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GymRoutinesProvider call(String gymId) =>
      GymRoutinesProvider._(argument: gymId, from: this);

  @override
  String toString() => r'gymRoutinesProvider';
}

@ProviderFor(routine)
final routineProvider = RoutineFamily._();

final class RoutineProvider
    extends
        $FunctionalProvider<AsyncValue<Routine?>, Routine?, Stream<Routine?>>
    with $FutureModifier<Routine?>, $StreamProvider<Routine?> {
  RoutineProvider._({
    required RoutineFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'routineProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$routineHash();

  @override
  String toString() {
    return r'routineProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Routine?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Routine?> create(Ref ref) {
    final argument = this.argument as String;
    return routine(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RoutineProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$routineHash() => r'88cdfd1f67782c5d6386555a74b7a8291f2fe442';

final class RoutineFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Routine?>, String> {
  RoutineFamily._()
    : super(
        retry: null,
        name: r'routineProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RoutineProvider call(String id) =>
      RoutineProvider._(argument: id, from: this);

  @override
  String toString() => r'routineProvider';
}

@ProviderFor(routineLastDone)
final routineLastDoneProvider = RoutineLastDoneFamily._();

final class RoutineLastDoneProvider
    extends
        $FunctionalProvider<AsyncValue<DateTime?>, DateTime?, Stream<DateTime?>>
    with $FutureModifier<DateTime?>, $StreamProvider<DateTime?> {
  RoutineLastDoneProvider._({
    required RoutineLastDoneFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'routineLastDoneProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$routineLastDoneHash();

  @override
  String toString() {
    return r'routineLastDoneProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<DateTime?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<DateTime?> create(Ref ref) {
    final argument = this.argument as String;
    return routineLastDone(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RoutineLastDoneProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$routineLastDoneHash() => r'2072639cf080636b109bab5b8f5e68ffad98b314';

final class RoutineLastDoneFamily extends $Family
    with $FunctionalFamilyOverride<Stream<DateTime?>, String> {
  RoutineLastDoneFamily._()
    : super(
        retry: null,
        name: r'routineLastDoneProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RoutineLastDoneProvider call(String routineId) =>
      RoutineLastDoneProvider._(argument: routineId, from: this);

  @override
  String toString() => r'routineLastDoneProvider';
}

@ProviderFor(routineItems)
final routineItemsProvider = RoutineItemsFamily._();

final class RoutineItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RoutineItemView>>,
          List<RoutineItemView>,
          Stream<List<RoutineItemView>>
        >
    with
        $FutureModifier<List<RoutineItemView>>,
        $StreamProvider<List<RoutineItemView>> {
  RoutineItemsProvider._({
    required RoutineItemsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'routineItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$routineItemsHash();

  @override
  String toString() {
    return r'routineItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<RoutineItemView>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RoutineItemView>> create(Ref ref) {
    final argument = this.argument as String;
    return routineItems(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RoutineItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$routineItemsHash() => r'9edcc580a38d60000fcb80cfbb1e082f6078eb51';

final class RoutineItemsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<RoutineItemView>>, String> {
  RoutineItemsFamily._()
    : super(
        retry: null,
        name: r'routineItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RoutineItemsProvider call(String routineId) =>
      RoutineItemsProvider._(argument: routineId, from: this);

  @override
  String toString() => r'routineItemsProvider';
}

/// Próxima ficha do rodízio (recalcula quando a lista muda).

@ProviderFor(nextRoutine)
final nextRoutineProvider = NextRoutineFamily._();

/// Próxima ficha do rodízio (recalcula quando a lista muda).

final class NextRoutineProvider
    extends
        $FunctionalProvider<
          AsyncValue<RoutineSummary?>,
          RoutineSummary?,
          FutureOr<RoutineSummary?>
        >
    with $FutureModifier<RoutineSummary?>, $FutureProvider<RoutineSummary?> {
  /// Próxima ficha do rodízio (recalcula quando a lista muda).
  NextRoutineProvider._({
    required NextRoutineFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'nextRoutineProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$nextRoutineHash();

  @override
  String toString() {
    return r'nextRoutineProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<RoutineSummary?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RoutineSummary?> create(Ref ref) {
    final argument = this.argument as String;
    return nextRoutine(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NextRoutineProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$nextRoutineHash() => r'490359d2c6de4a89119e0117b10622badda7a0c1';

/// Próxima ficha do rodízio (recalcula quando a lista muda).

final class NextRoutineFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RoutineSummary?>, String> {
  NextRoutineFamily._()
    : super(
        retry: null,
        name: r'nextRoutineProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Próxima ficha do rodízio (recalcula quando a lista muda).

  NextRoutineProvider call(String gymId) =>
      NextRoutineProvider._(argument: gymId, from: this);

  @override
  String toString() => r'nextRoutineProvider';
}

@ProviderFor(_finishedCount)
final _finishedCountProvider = _FinishedCountFamily._();

final class _FinishedCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  _FinishedCountProvider._({
    required _FinishedCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'_finishedCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$_finishedCountHash();

  @override
  String toString() {
    return r'_finishedCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as String;
    return _finishedCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is _FinishedCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_finishedCountHash() => r'2ca272ade9cab09de70d75f608fd919da80e34c6';

final class _FinishedCountFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, String> {
  _FinishedCountFamily._()
    : super(
        retry: null,
        name: r'_finishedCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _FinishedCountProvider call(String gymId) =>
      _FinishedCountProvider._(argument: gymId, from: this);

  @override
  String toString() => r'_finishedCountProvider';
}
