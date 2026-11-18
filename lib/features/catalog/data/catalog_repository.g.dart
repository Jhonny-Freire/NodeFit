// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(catalogRepository)
final catalogRepositoryProvider = CatalogRepositoryProvider._();

final class CatalogRepositoryProvider
    extends
        $FunctionalProvider<
          CatalogRepository,
          CatalogRepository,
          CatalogRepository
        >
    with $Provider<CatalogRepository> {
  CatalogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogRepositoryHash();

  @$internal
  @override
  $ProviderElement<CatalogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CatalogRepository create(Ref ref) {
    return catalogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogRepository>(value),
    );
  }
}

String _$catalogRepositoryHash() => r'40a1e5618c1f748cafad788a05d86890c30b559a';

@ProviderFor(exerciseSearch)
final exerciseSearchProvider = ExerciseSearchFamily._();

final class ExerciseSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Exercise>>,
          List<Exercise>,
          Stream<List<Exercise>>
        >
    with $FutureModifier<List<Exercise>>, $StreamProvider<List<Exercise>> {
  ExerciseSearchProvider._({
    required ExerciseSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'exerciseSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exerciseSearchHash();

  @override
  String toString() {
    return r'exerciseSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Exercise>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Exercise>> create(Ref ref) {
    final argument = this.argument as String;
    return exerciseSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exerciseSearchHash() => r'990bb95bfefdd6e3078de91bc096e64fd83a95a5';

final class ExerciseSearchFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Exercise>>, String> {
  ExerciseSearchFamily._()
    : super(
        retry: null,
        name: r'exerciseSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExerciseSearchProvider call(String query) =>
      ExerciseSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'exerciseSearchProvider';
}

@ProviderFor(recentExercises)
final recentExercisesProvider = RecentExercisesFamily._();

final class RecentExercisesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecentExercise>>,
          List<RecentExercise>,
          Stream<List<RecentExercise>>
        >
    with
        $FutureModifier<List<RecentExercise>>,
        $StreamProvider<List<RecentExercise>> {
  RecentExercisesProvider._({
    required RecentExercisesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'recentExercisesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recentExercisesHash();

  @override
  String toString() {
    return r'recentExercisesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<RecentExercise>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RecentExercise>> create(Ref ref) {
    final argument = this.argument as String;
    return recentExercises(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentExercisesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recentExercisesHash() => r'ecdb2a265146c0e78bce60f348d320f01418afd7';

final class RecentExercisesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<RecentExercise>>, String> {
  RecentExercisesFamily._()
    : super(
        retry: null,
        name: r'recentExercisesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RecentExercisesProvider call(String gymId) =>
      RecentExercisesProvider._(argument: gymId, from: this);

  @override
  String toString() => r'recentExercisesProvider';
}

@ProviderFor(doneExerciseIds)
final doneExerciseIdsProvider = DoneExerciseIdsFamily._();

final class DoneExerciseIdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          Stream<Set<String>>
        >
    with $FutureModifier<Set<String>>, $StreamProvider<Set<String>> {
  DoneExerciseIdsProvider._({
    required DoneExerciseIdsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'doneExerciseIdsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$doneExerciseIdsHash();

  @override
  String toString() {
    return r'doneExerciseIdsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Set<String>> create(Ref ref) {
    final argument = this.argument as String;
    return doneExerciseIds(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DoneExerciseIdsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$doneExerciseIdsHash() => r'c3f3ffd0d6a39f27853a94be80d2f35cbd9fbeba';

final class DoneExerciseIdsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Set<String>>, String> {
  DoneExerciseIdsFamily._()
    : super(
        retry: null,
        name: r'doneExerciseIdsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DoneExerciseIdsProvider call(String gymId) =>
      DoneExerciseIdsProvider._(argument: gymId, from: this);

  @override
  String toString() => r'doneExerciseIdsProvider';
}

@ProviderFor(exercise)
final exerciseProvider = ExerciseFamily._();

final class ExerciseProvider
    extends
        $FunctionalProvider<AsyncValue<Exercise?>, Exercise?, Stream<Exercise?>>
    with $FutureModifier<Exercise?>, $StreamProvider<Exercise?> {
  ExerciseProvider._({
    required ExerciseFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'exerciseProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exerciseHash();

  @override
  String toString() {
    return r'exerciseProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Exercise?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Exercise?> create(Ref ref) {
    final argument = this.argument as String;
    return exercise(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exerciseHash() => r'759df1eb8b5ca26735762628becf84465af4991f';

final class ExerciseFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Exercise?>, String> {
  ExerciseFamily._()
    : super(
        retry: null,
        name: r'exerciseProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExerciseProvider call(String id) =>
      ExerciseProvider._(argument: id, from: this);

  @override
  String toString() => r'exerciseProvider';
}
