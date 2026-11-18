// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reportRepository)
final reportRepositoryProvider = ReportRepositoryProvider._();

final class ReportRepositoryProvider
    extends
        $FunctionalProvider<
          ReportRepository,
          ReportRepository,
          ReportRepository
        >
    with $Provider<ReportRepository> {
  ReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReportRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReportRepository create(Ref ref) {
    return reportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportRepository>(value),
    );
  }
}

String _$reportRepositoryHash() => r'1be4e231be38c592cea2e614877f781d583c9682';

/// Texto pronto do relatório para [audience] nas últimas [weeks] semanas.

@ProviderFor(reportText)
final reportTextProvider = ReportTextFamily._();

/// Texto pronto do relatório para [audience] nas últimas [weeks] semanas.

final class ReportTextProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// Texto pronto do relatório para [audience] nas últimas [weeks] semanas.
  ReportTextProvider._({
    required ReportTextFamily super.from,
    required (ReportAudience, int) super.argument,
  }) : super(
         retry: null,
         name: r'reportTextProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reportTextHash();

  @override
  String toString() {
    return r'reportTextProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as (ReportAudience, int);
    return reportText(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportTextProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reportTextHash() => r'ebb1bf4d3b902b0f328e3caece5dea44e8da9b0c';

/// Texto pronto do relatório para [audience] nas últimas [weeks] semanas.

final class ReportTextFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, (ReportAudience, int)> {
  ReportTextFamily._()
    : super(
        retry: null,
        name: r'reportTextProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Texto pronto do relatório para [audience] nas últimas [weeks] semanas.

  ReportTextProvider call(ReportAudience audience, int weeks) =>
      ReportTextProvider._(argument: (audience, weeks), from: this);

  @override
  String toString() => r'reportTextProvider';
}
