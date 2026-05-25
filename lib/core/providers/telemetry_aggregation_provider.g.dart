// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telemetry_aggregation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$telemetrySeriesHash() => r'b537dd08e3bfb03d31730d021e50351eff14a177';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

////////////////////////////////////////////////////////////
/// FETCH TELEMETRY SERIES
////////////////////////////////////////////////////////////
///
/// Copied from [telemetrySeries].
@ProviderFor(telemetrySeries)
const telemetrySeriesProvider = TelemetrySeriesFamily();

////////////////////////////////////////////////////////////
/// FETCH TELEMETRY SERIES
////////////////////////////////////////////////////////////
///
/// Copied from [telemetrySeries].
class TelemetrySeriesFamily extends Family<AsyncValue<TelemetrySeries>> {
  ////////////////////////////////////////////////////////////
  /// FETCH TELEMETRY SERIES
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [telemetrySeries].
  const TelemetrySeriesFamily();

  ////////////////////////////////////////////////////////////
  /// FETCH TELEMETRY SERIES
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [telemetrySeries].
  TelemetrySeriesProvider call(TelemetrySeriesParams params) {
    return TelemetrySeriesProvider(params);
  }

  @override
  TelemetrySeriesProvider getProviderOverride(
    covariant TelemetrySeriesProvider provider,
  ) {
    return call(provider.params);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'telemetrySeriesProvider';
}

////////////////////////////////////////////////////////////
/// FETCH TELEMETRY SERIES
////////////////////////////////////////////////////////////
///
/// Copied from [telemetrySeries].
class TelemetrySeriesProvider
    extends AutoDisposeFutureProvider<TelemetrySeries> {
  ////////////////////////////////////////////////////////////
  /// FETCH TELEMETRY SERIES
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [telemetrySeries].
  TelemetrySeriesProvider(TelemetrySeriesParams params)
    : this._internal(
        (ref) => telemetrySeries(ref as TelemetrySeriesRef, params),
        from: telemetrySeriesProvider,
        name: r'telemetrySeriesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$telemetrySeriesHash,
        dependencies: TelemetrySeriesFamily._dependencies,
        allTransitiveDependencies:
            TelemetrySeriesFamily._allTransitiveDependencies,
        params: params,
      );

  TelemetrySeriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final TelemetrySeriesParams params;

  @override
  Override overrideWith(
    FutureOr<TelemetrySeries> Function(TelemetrySeriesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TelemetrySeriesProvider._internal(
        (ref) => create(ref as TelemetrySeriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TelemetrySeries> createElement() {
    return _TelemetrySeriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TelemetrySeriesProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TelemetrySeriesRef on AutoDisposeFutureProviderRef<TelemetrySeries> {
  /// The parameter `params` of this provider.
  TelemetrySeriesParams get params;
}

class _TelemetrySeriesProviderElement
    extends AutoDisposeFutureProviderElement<TelemetrySeries>
    with TelemetrySeriesRef {
  _TelemetrySeriesProviderElement(super.provider);

  @override
  TelemetrySeriesParams get params =>
      (origin as TelemetrySeriesProvider).params;
}

String _$multiParameterTelemetryHash() =>
    r'357896238b0ea04952ee3cf6602735f8583ed217';

/// See also [multiParameterTelemetry].
@ProviderFor(multiParameterTelemetry)
const multiParameterTelemetryProvider = MultiParameterTelemetryFamily();

/// See also [multiParameterTelemetry].
class MultiParameterTelemetryFamily
    extends Family<AsyncValue<Map<String, TelemetrySeries>>> {
  /// See also [multiParameterTelemetry].
  const MultiParameterTelemetryFamily();

  /// See also [multiParameterTelemetry].
  MultiParameterTelemetryProvider call(MultiParameterParams params) {
    return MultiParameterTelemetryProvider(params);
  }

  @override
  MultiParameterTelemetryProvider getProviderOverride(
    covariant MultiParameterTelemetryProvider provider,
  ) {
    return call(provider.params);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'multiParameterTelemetryProvider';
}

/// See also [multiParameterTelemetry].
class MultiParameterTelemetryProvider
    extends AutoDisposeFutureProvider<Map<String, TelemetrySeries>> {
  /// See also [multiParameterTelemetry].
  MultiParameterTelemetryProvider(MultiParameterParams params)
    : this._internal(
        (ref) =>
            multiParameterTelemetry(ref as MultiParameterTelemetryRef, params),
        from: multiParameterTelemetryProvider,
        name: r'multiParameterTelemetryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$multiParameterTelemetryHash,
        dependencies: MultiParameterTelemetryFamily._dependencies,
        allTransitiveDependencies:
            MultiParameterTelemetryFamily._allTransitiveDependencies,
        params: params,
      );

  MultiParameterTelemetryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final MultiParameterParams params;

  @override
  Override overrideWith(
    FutureOr<Map<String, TelemetrySeries>> Function(
      MultiParameterTelemetryRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MultiParameterTelemetryProvider._internal(
        (ref) => create(ref as MultiParameterTelemetryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, TelemetrySeries>>
  createElement() {
    return _MultiParameterTelemetryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MultiParameterTelemetryProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MultiParameterTelemetryRef
    on AutoDisposeFutureProviderRef<Map<String, TelemetrySeries>> {
  /// The parameter `params` of this provider.
  MultiParameterParams get params;
}

class _MultiParameterTelemetryProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, TelemetrySeries>>
    with MultiParameterTelemetryRef {
  _MultiParameterTelemetryProviderElement(super.provider);

  @override
  MultiParameterParams get params =>
      (origin as MultiParameterTelemetryProvider).params;
}

String _$comparisonTelemetryHash() =>
    r'43232511aee42e7bdc677860373668810d8488c4';

/// See also [comparisonTelemetry].
@ProviderFor(comparisonTelemetry)
const comparisonTelemetryProvider = ComparisonTelemetryFamily();

/// See also [comparisonTelemetry].
class ComparisonTelemetryFamily
    extends Family<AsyncValue<Map<String, TelemetrySeries>>> {
  /// See also [comparisonTelemetry].
  const ComparisonTelemetryFamily();

  /// See also [comparisonTelemetry].
  ComparisonTelemetryProvider call(ComparisonParams params) {
    return ComparisonTelemetryProvider(params);
  }

  @override
  ComparisonTelemetryProvider getProviderOverride(
    covariant ComparisonTelemetryProvider provider,
  ) {
    return call(provider.params);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'comparisonTelemetryProvider';
}

/// See also [comparisonTelemetry].
class ComparisonTelemetryProvider
    extends AutoDisposeFutureProvider<Map<String, TelemetrySeries>> {
  /// See also [comparisonTelemetry].
  ComparisonTelemetryProvider(ComparisonParams params)
    : this._internal(
        (ref) => comparisonTelemetry(ref as ComparisonTelemetryRef, params),
        from: comparisonTelemetryProvider,
        name: r'comparisonTelemetryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$comparisonTelemetryHash,
        dependencies: ComparisonTelemetryFamily._dependencies,
        allTransitiveDependencies:
            ComparisonTelemetryFamily._allTransitiveDependencies,
        params: params,
      );

  ComparisonTelemetryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final ComparisonParams params;

  @override
  Override overrideWith(
    FutureOr<Map<String, TelemetrySeries>> Function(
      ComparisonTelemetryRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ComparisonTelemetryProvider._internal(
        (ref) => create(ref as ComparisonTelemetryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, TelemetrySeries>>
  createElement() {
    return _ComparisonTelemetryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ComparisonTelemetryProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ComparisonTelemetryRef
    on AutoDisposeFutureProviderRef<Map<String, TelemetrySeries>> {
  /// The parameter `params` of this provider.
  ComparisonParams get params;
}

class _ComparisonTelemetryProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, TelemetrySeries>>
    with ComparisonTelemetryRef {
  _ComparisonTelemetryProviderElement(super.provider);

  @override
  ComparisonParams get params => (origin as ComparisonTelemetryProvider).params;
}

String _$selectedTimeframeHash() =>
    r'a925537ab47221f4caf01c7d548168c08c88503f'; ////////////////////////////////////////////////////////////
/// SELECTED TIMEFRAME STATE
////////////////////////////////////////////////////////////
///
/// Copied from [SelectedTimeframe].
@ProviderFor(SelectedTimeframe)
final selectedTimeframeProvider =
    NotifierProvider<SelectedTimeframe, String>.internal(
      SelectedTimeframe.new,
      name: r'selectedTimeframeProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedTimeframeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedTimeframe = Notifier<String>;
String _$selectedAggregationHash() =>
    r'8e380b6a3949db60cca8e91a0c261891ed2666ff'; ////////////////////////////////////////////////////////////
/// SELECTED AGGREGATION STATE
////////////////////////////////////////////////////////////
///
/// Copied from [SelectedAggregation].
@ProviderFor(SelectedAggregation)
final selectedAggregationProvider =
    NotifierProvider<SelectedAggregation, String>.internal(
      SelectedAggregation.new,
      name: r'selectedAggregationProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedAggregationHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedAggregation = Notifier<String>;
String _$timeFormatPreferenceHash() =>
    r'1c40699839bb8b569fc98698ae33ff90b4d13323'; ////////////////////////////////////////////////////////////
/// TIME FORMAT PREFERENCE (12H/24H)
////////////////////////////////////////////////////////////
///
/// Copied from [TimeFormatPreference].
@ProviderFor(TimeFormatPreference)
final timeFormatPreferenceProvider =
    NotifierProvider<TimeFormatPreference, String>.internal(
      TimeFormatPreference.new,
      name: r'timeFormatPreferenceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$timeFormatPreferenceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TimeFormatPreference = Notifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
