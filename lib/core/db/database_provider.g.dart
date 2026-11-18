// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// O banco é a fonte da verdade. Nos testes, sobrescreva com
/// `appDatabaseProvider.overrideWithValue(AppDatabase(NativeDatabase.memory()))`.

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// O banco é a fonte da verdade. Nos testes, sobrescreva com
/// `appDatabaseProvider.overrideWithValue(AppDatabase(NativeDatabase.memory()))`.

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// O banco é a fonte da verdade. Nos testes, sobrescreva com
  /// `appDatabaseProvider.overrideWithValue(AppDatabase(NativeDatabase.memory()))`.
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'59cce38d45eeaba199eddd097d8e149d66f9f3e1';
