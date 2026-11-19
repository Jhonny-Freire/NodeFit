// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'startup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Roda uma vez antes da primeira tela: abre o banco e aplica o catálogo
/// embarcado (só grava se a versão do arquivo for nova).

@ProviderFor(appStartup)
final appStartupProvider = AppStartupProvider._();

/// Roda uma vez antes da primeira tela: abre o banco e aplica o catálogo
/// embarcado (só grava se a versão do arquivo for nova).

final class AppStartupProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Roda uma vez antes da primeira tela: abre o banco e aplica o catálogo
  /// embarcado (só grava se a versão do arquivo for nova).
  AppStartupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appStartupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appStartupHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return appStartup(ref);
  }
}

String _$appStartupHash() => r'85c6c5726b544f90cefcbb082a04b4a3835c9a92';
