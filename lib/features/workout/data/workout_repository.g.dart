// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workoutRepository)
final workoutRepositoryProvider = WorkoutRepositoryProvider._();

final class WorkoutRepositoryProvider
    extends
        $FunctionalProvider<
          WorkoutRepository,
          WorkoutRepository,
          WorkoutRepository
        >
    with $Provider<WorkoutRepository> {
  WorkoutRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutRepositoryHash();

  @$internal
  @override
  $ProviderElement<WorkoutRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WorkoutRepository create(Ref ref) {
    return workoutRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutRepository>(value),
    );
  }
}

String _$workoutRepositoryHash() => r'9298cedb81fbc3848718eae9bb15691977cfbade';

@ProviderFor(activeSession)
final activeSessionProvider = ActiveSessionProvider._();

final class ActiveSessionProvider
    extends
        $FunctionalProvider<
          AsyncValue<WorkoutSession?>,
          WorkoutSession?,
          Stream<WorkoutSession?>
        >
    with $FutureModifier<WorkoutSession?>, $StreamProvider<WorkoutSession?> {
  ActiveSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeSessionHash();

  @$internal
  @override
  $StreamProviderElement<WorkoutSession?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<WorkoutSession?> create(Ref ref) {
    return activeSession(ref);
  }
}

String _$activeSessionHash() => r'eb983c7a70057af95122faac2d372add8de77315';

@ProviderFor(session)
final sessionProvider = SessionFamily._();

final class SessionProvider
    extends
        $FunctionalProvider<
          AsyncValue<WorkoutSession?>,
          WorkoutSession?,
          Stream<WorkoutSession?>
        >
    with $FutureModifier<WorkoutSession?>, $StreamProvider<WorkoutSession?> {
  SessionProvider._({
    required SessionFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sessionHash();

  @override
  String toString() {
    return r'sessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<WorkoutSession?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<WorkoutSession?> create(Ref ref) {
    final argument = this.argument as String;
    return session(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionHash() => r'e1bc64a6f8e67f7144da95fbbe516aef836b06c3';

final class SessionFamily extends $Family
    with $FunctionalFamilyOverride<Stream<WorkoutSession?>, String> {
  SessionFamily._()
    : super(
        retry: null,
        name: r'sessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SessionProvider call(String id) =>
      SessionProvider._(argument: id, from: this);

  @override
  String toString() => r'sessionProvider';
}

@ProviderFor(sessionExercises)
final sessionExercisesProvider = SessionExercisesFamily._();

final class SessionExercisesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SessionExerciseView>>,
          List<SessionExerciseView>,
          Stream<List<SessionExerciseView>>
        >
    with
        $FutureModifier<List<SessionExerciseView>>,
        $StreamProvider<List<SessionExerciseView>> {
  SessionExercisesProvider._({
    required SessionExercisesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sessionExercisesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sessionExercisesHash();

  @override
  String toString() {
    return r'sessionExercisesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<SessionExerciseView>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SessionExerciseView>> create(Ref ref) {
    final argument = this.argument as String;
    return sessionExercises(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionExercisesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionExercisesHash() => r'3d35ff6cb2ffffe872ac09b8ef3e2031dd0d255e';

final class SessionExercisesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<SessionExerciseView>>, String> {
  SessionExercisesFamily._()
    : super(
        retry: null,
        name: r'sessionExercisesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SessionExercisesProvider call(String sessionId) =>
      SessionExercisesProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'sessionExercisesProvider';
}

@ProviderFor(exerciseSets)
final exerciseSetsProvider = ExerciseSetsFamily._();

final class ExerciseSetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WorkoutSet>>,
          List<WorkoutSet>,
          Stream<List<WorkoutSet>>
        >
    with $FutureModifier<List<WorkoutSet>>, $StreamProvider<List<WorkoutSet>> {
  ExerciseSetsProvider._({
    required ExerciseSetsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'exerciseSetsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exerciseSetsHash();

  @override
  String toString() {
    return r'exerciseSetsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<WorkoutSet>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<WorkoutSet>> create(Ref ref) {
    final argument = this.argument as String;
    return exerciseSets(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseSetsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exerciseSetsHash() => r'576aec9fbe3b790f4b36641ee4ab0ced42daa986';

final class ExerciseSetsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<WorkoutSet>>, String> {
  ExerciseSetsFamily._()
    : super(
        retry: null,
        name: r'exerciseSetsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExerciseSetsProvider call(String sessionExerciseId) =>
      ExerciseSetsProvider._(argument: sessionExerciseId, from: this);

  @override
  String toString() => r'exerciseSetsProvider';
}

/// "Anterior" da estação, sem contar o treino atual. Não muda durante o
/// treino, por isso é um Future.

@ProviderFor(previousPerformance)
final previousPerformanceProvider = PreviousPerformanceFamily._();

/// "Anterior" da estação, sem contar o treino atual. Não muda durante o
/// treino, por isso é um Future.

final class PreviousPerformanceProvider
    extends
        $FunctionalProvider<
          AsyncValue<PreviousPerformance?>,
          PreviousPerformance?,
          FutureOr<PreviousPerformance?>
        >
    with
        $FutureModifier<PreviousPerformance?>,
        $FutureProvider<PreviousPerformance?> {
  /// "Anterior" da estação, sem contar o treino atual. Não muda durante o
  /// treino, por isso é um Future.
  PreviousPerformanceProvider._({
    required PreviousPerformanceFamily super.from,
    required ({
      String stationId,
      String sessionId,
      String exerciseId,
      String gymId,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'previousPerformanceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$previousPerformanceHash();

  @override
  String toString() {
    return r'previousPerformanceProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PreviousPerformance?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PreviousPerformance?> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String stationId,
              String sessionId,
              String exerciseId,
              String gymId,
            });
    return previousPerformance(
      ref,
      stationId: argument.stationId,
      sessionId: argument.sessionId,
      exerciseId: argument.exerciseId,
      gymId: argument.gymId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PreviousPerformanceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$previousPerformanceHash() =>
    r'0868dae9e87ee5b7736ff298780141334dcebe3a';

/// "Anterior" da estação, sem contar o treino atual. Não muda durante o
/// treino, por isso é um Future.

final class PreviousPerformanceFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PreviousPerformance?>,
          ({
            String stationId,
            String sessionId,
            String exerciseId,
            String gymId,
          })
        > {
  PreviousPerformanceFamily._()
    : super(
        retry: null,
        name: r'previousPerformanceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// "Anterior" da estação, sem contar o treino atual. Não muda durante o
  /// treino, por isso é um Future.

  PreviousPerformanceProvider call({
    required String stationId,
    required String sessionId,
    required String exerciseId,
    required String gymId,
  }) => PreviousPerformanceProvider._(
    argument: (
      stationId: stationId,
      sessionId: sessionId,
      exerciseId: exerciseId,
      gymId: gymId,
    ),
    from: this,
  );

  @override
  String toString() => r'previousPerformanceProvider';
}

@ProviderFor(sessionSummary)
final sessionSummaryProvider = SessionSummaryFamily._();

final class SessionSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<SessionSummary>,
          SessionSummary,
          FutureOr<SessionSummary>
        >
    with $FutureModifier<SessionSummary>, $FutureProvider<SessionSummary> {
  SessionSummaryProvider._({
    required SessionSummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sessionSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sessionSummaryHash();

  @override
  String toString() {
    return r'sessionSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SessionSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SessionSummary> create(Ref ref) {
    final argument = this.argument as String;
    return sessionSummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionSummaryHash() => r'0ba49061f85a69bdccf178681abf08eae0e39f76';

final class SessionSummaryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SessionSummary>, String> {
  SessionSummaryFamily._()
    : super(
        retry: null,
        name: r'sessionSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SessionSummaryProvider call(String sessionId) =>
      SessionSummaryProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'sessionSummaryProvider';
}

@ProviderFor(history)
final historyProvider = HistoryProvider._();

final class HistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HistoryEntry>>,
          List<HistoryEntry>,
          Stream<List<HistoryEntry>>
        >
    with
        $FutureModifier<List<HistoryEntry>>,
        $StreamProvider<List<HistoryEntry>> {
  HistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyHash();

  @$internal
  @override
  $StreamProviderElement<List<HistoryEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<HistoryEntry>> create(Ref ref) {
    return history(ref);
  }
}

String _$historyHash() => r'5eae984c36efa7d6f7e50bfbfee97726101bd6e5';

@ProviderFor(sessionSets)
final sessionSetsProvider = SessionSetsFamily._();

final class SessionSetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<WorkoutSet>>>,
          Map<String, List<WorkoutSet>>,
          Stream<Map<String, List<WorkoutSet>>>
        >
    with
        $FutureModifier<Map<String, List<WorkoutSet>>>,
        $StreamProvider<Map<String, List<WorkoutSet>>> {
  SessionSetsProvider._({
    required SessionSetsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sessionSetsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sessionSetsHash();

  @override
  String toString() {
    return r'sessionSetsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Map<String, List<WorkoutSet>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, List<WorkoutSet>>> create(Ref ref) {
    final argument = this.argument as String;
    return sessionSets(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionSetsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionSetsHash() => r'070eccaa775fa3bf7166ea534ffa86963d46d270';

final class SessionSetsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<Map<String, List<WorkoutSet>>>,
          String
        > {
  SessionSetsFamily._()
    : super(
        retry: null,
        name: r'sessionSetsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SessionSetsProvider call(String sessionId) =>
      SessionSetsProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'sessionSetsProvider';
}

@ProviderFor(stationHistory)
final stationHistoryProvider = StationHistoryFamily._();

final class StationHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StationHistoryEntry>>,
          List<StationHistoryEntry>,
          Stream<List<StationHistoryEntry>>
        >
    with
        $FutureModifier<List<StationHistoryEntry>>,
        $StreamProvider<List<StationHistoryEntry>> {
  StationHistoryProvider._({
    required StationHistoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stationHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stationHistoryHash();

  @override
  String toString() {
    return r'stationHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<StationHistoryEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<StationHistoryEntry>> create(Ref ref) {
    final argument = this.argument as String;
    return stationHistory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StationHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stationHistoryHash() => r'02b7eb0010af36fe3d2dd41912e0b7d6b34de15b';

final class StationHistoryFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<StationHistoryEntry>>, String> {
  StationHistoryFamily._()
    : super(
        retry: null,
        name: r'stationHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StationHistoryProvider call(String stationId) =>
      StationHistoryProvider._(argument: stationId, from: this);

  @override
  String toString() => r'stationHistoryProvider';
}

/// Até 40 treinos na estação, prontos para o gráfico.

@ProviderFor(stationProgress)
final stationProgressProvider = StationProgressFamily._();

/// Até 40 treinos na estação, prontos para o gráfico.

final class StationProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProgressPoint>>,
          List<ProgressPoint>,
          Stream<List<ProgressPoint>>
        >
    with
        $FutureModifier<List<ProgressPoint>>,
        $StreamProvider<List<ProgressPoint>> {
  /// Até 40 treinos na estação, prontos para o gráfico.
  StationProgressProvider._({
    required StationProgressFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stationProgressProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stationProgressHash();

  @override
  String toString() {
    return r'stationProgressProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ProgressPoint>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ProgressPoint>> create(Ref ref) {
    final argument = this.argument as String;
    return stationProgress(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StationProgressProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stationProgressHash() => r'1e8af96e86e92a5a3dc170b4920157674830f5ca';

/// Até 40 treinos na estação, prontos para o gráfico.

final class StationProgressFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ProgressPoint>>, String> {
  StationProgressFamily._()
    : super(
        retry: null,
        name: r'stationProgressProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Até 40 treinos na estação, prontos para o gráfico.

  StationProgressProvider call(String stationId) =>
      StationProgressProvider._(argument: stationId, from: this);

  @override
  String toString() => r'stationProgressProvider';
}

/// Séries por músculo nos últimos 7 dias (1 no primário, 0,5 no
/// secundário). O "agora" é fixado ao abrir a tela.

@ProviderFor(weeklyMuscleVolume)
final weeklyMuscleVolumeProvider = WeeklyMuscleVolumeProvider._();

/// Séries por músculo nos últimos 7 dias (1 no primário, 0,5 no
/// secundário). O "agora" é fixado ao abrir a tela.

final class WeeklyMuscleVolumeProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, double>>,
          Map<String, double>,
          Stream<Map<String, double>>
        >
    with
        $FutureModifier<Map<String, double>>,
        $StreamProvider<Map<String, double>> {
  /// Séries por músculo nos últimos 7 dias (1 no primário, 0,5 no
  /// secundário). O "agora" é fixado ao abrir a tela.
  WeeklyMuscleVolumeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyMuscleVolumeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyMuscleVolumeHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, double>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, double>> create(Ref ref) {
    return weeklyMuscleVolume(ref);
  }
}

String _$weeklyMuscleVolumeHash() =>
    r'5454ceed19034ec0355bdcc16e6253145fa77606';
