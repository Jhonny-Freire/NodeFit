// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prefs_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(prefsRepository)
final prefsRepositoryProvider = PrefsRepositoryProvider._();

final class PrefsRepositoryProvider
    extends
        $FunctionalProvider<PrefsRepository, PrefsRepository, PrefsRepository>
    with $Provider<PrefsRepository> {
  PrefsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prefsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prefsRepositoryHash();

  @$internal
  @override
  $ProviderElement<PrefsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrefsRepository create(Ref ref) {
    return prefsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrefsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrefsRepository>(value),
    );
  }
}

String _$prefsRepositoryHash() => r'fb3b94ae59a36958a8cc929c795f920a076d210a';

/// Descanso padrão em segundos (90 se nunca foi definido).

@ProviderFor(defaultRestSec)
final defaultRestSecProvider = DefaultRestSecProvider._();

/// Descanso padrão em segundos (90 se nunca foi definido).

final class DefaultRestSecProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Descanso padrão em segundos (90 se nunca foi definido).
  DefaultRestSecProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'defaultRestSecProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$defaultRestSecHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return defaultRestSec(ref);
  }
}

String _$defaultRestSecHash() => r'd3e9ff23b233ea9985030c1334303133a41519af';

/// Manter a tela ligada durante o treino (padrão: sim).

@ProviderFor(keepScreenOn)
final keepScreenOnProvider = KeepScreenOnProvider._();

/// Manter a tela ligada durante o treino (padrão: sim).

final class KeepScreenOnProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Manter a tela ligada durante o treino (padrão: sim).
  KeepScreenOnProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keepScreenOnProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keepScreenOnHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return keepScreenOn(ref);
  }
}

String _$keepScreenOnHash() => r'4b049b4e33756bc9a368607e456e4bfbba639a87';

/// Quando foi o último backup exportado (null = nunca).

@ProviderFor(lastBackupAt)
final lastBackupAtProvider = LastBackupAtProvider._();

/// Quando foi o último backup exportado (null = nunca).

final class LastBackupAtProvider
    extends
        $FunctionalProvider<AsyncValue<DateTime?>, DateTime?, Stream<DateTime?>>
    with $FutureModifier<DateTime?>, $StreamProvider<DateTime?> {
  /// Quando foi o último backup exportado (null = nunca).
  LastBackupAtProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastBackupAtProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastBackupAtHash();

  @$internal
  @override
  $StreamProviderElement<DateTime?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<DateTime?> create(Ref ref) {
    return lastBackupAt(ref);
  }
}

String _$lastBackupAtHash() => r'107ceabf887aa4678aebb047dd043613a3cf4339';
