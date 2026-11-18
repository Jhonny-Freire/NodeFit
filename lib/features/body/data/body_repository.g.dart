// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bodyRepository)
final bodyRepositoryProvider = BodyRepositoryProvider._();

final class BodyRepositoryProvider
    extends $FunctionalProvider<BodyRepository, BodyRepository, BodyRepository>
    with $Provider<BodyRepository> {
  BodyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bodyRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bodyRepositoryHash();

  @$internal
  @override
  $ProviderElement<BodyRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BodyRepository create(Ref ref) {
    return bodyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BodyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BodyRepository>(value),
    );
  }
}

String _$bodyRepositoryHash() => r'b140bc7498a65021ae92b21f407e5d67b6749931';

@ProviderFor(bodyProfile)
final bodyProfileProvider = BodyProfileProvider._();

final class BodyProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<BodyProfile>,
          BodyProfile,
          Stream<BodyProfile>
        >
    with $FutureModifier<BodyProfile>, $StreamProvider<BodyProfile> {
  BodyProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bodyProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bodyProfileHash();

  @$internal
  @override
  $StreamProviderElement<BodyProfile> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<BodyProfile> create(Ref ref) {
    return bodyProfile(ref);
  }
}

String _$bodyProfileHash() => r'c2c9ef6400d4d8f0a9f324b5da5d265ee2e01316';

@ProviderFor(checkins)
final checkinsProvider = CheckinsProvider._();

final class CheckinsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CheckinView>>,
          List<CheckinView>,
          Stream<List<CheckinView>>
        >
    with
        $FutureModifier<List<CheckinView>>,
        $StreamProvider<List<CheckinView>> {
  CheckinsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkinsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkinsHash();

  @$internal
  @override
  $StreamProviderElement<List<CheckinView>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CheckinView>> create(Ref ref) {
    return checkins(ref);
  }
}

String _$checkinsHash() => r'bace4a1ece6d0e47f3c0de0b9c3742fb216b7c5d';

@ProviderFor(bodySeries)
final bodySeriesProvider = BodySeriesFamily._();

final class BodySeriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BodyPoint>>,
          List<BodyPoint>,
          Stream<List<BodyPoint>>
        >
    with $FutureModifier<List<BodyPoint>>, $StreamProvider<List<BodyPoint>> {
  BodySeriesProvider._({
    required BodySeriesFamily super.from,
    required BodyMetric super.argument,
  }) : super(
         retry: null,
         name: r'bodySeriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bodySeriesHash();

  @override
  String toString() {
    return r'bodySeriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<BodyPoint>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<BodyPoint>> create(Ref ref) {
    final argument = this.argument as BodyMetric;
    return bodySeries(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BodySeriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bodySeriesHash() => r'f3a0bcaf8a1e838bc8e45bc4a6e6b0742ea84fc8';

final class BodySeriesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<BodyPoint>>, BodyMetric> {
  BodySeriesFamily._()
    : super(
        retry: null,
        name: r'bodySeriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BodySeriesProvider call(BodyMetric metric) =>
      BodySeriesProvider._(argument: metric, from: this);

  @override
  String toString() => r'bodySeriesProvider';
}
