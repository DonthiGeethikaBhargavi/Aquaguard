// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_chart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$analyticsChartHash() => r'f8262627a95a052709934142f3765cd02a7d54d1';

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

/// See also [analyticsChart].
@ProviderFor(analyticsChart)
const analyticsChartProvider = AnalyticsChartFamily();

/// See also [analyticsChart].
class AnalyticsChartFamily extends Family<AsyncValue<List<TelemetryPoint>>> {
  /// See also [analyticsChart].
  const AnalyticsChartFamily();

  /// See also [analyticsChart].
  AnalyticsChartProvider call(AnalyticsChartRequest request) {
    return AnalyticsChartProvider(request);
  }

  @override
  AnalyticsChartProvider getProviderOverride(
    covariant AnalyticsChartProvider provider,
  ) {
    return call(provider.request);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'analyticsChartProvider';
}

/// See also [analyticsChart].
class AnalyticsChartProvider
    extends AutoDisposeFutureProvider<List<TelemetryPoint>> {
  /// See also [analyticsChart].
  AnalyticsChartProvider(AnalyticsChartRequest request)
    : this._internal(
        (ref) => analyticsChart(ref as AnalyticsChartRef, request),
        from: analyticsChartProvider,
        name: r'analyticsChartProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$analyticsChartHash,
        dependencies: AnalyticsChartFamily._dependencies,
        allTransitiveDependencies:
            AnalyticsChartFamily._allTransitiveDependencies,
        request: request,
      );

  AnalyticsChartProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.request,
  }) : super.internal();

  final AnalyticsChartRequest request;

  @override
  Override overrideWith(
    FutureOr<List<TelemetryPoint>> Function(AnalyticsChartRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AnalyticsChartProvider._internal(
        (ref) => create(ref as AnalyticsChartRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        request: request,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TelemetryPoint>> createElement() {
    return _AnalyticsChartProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AnalyticsChartProvider && other.request == request;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, request.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AnalyticsChartRef on AutoDisposeFutureProviderRef<List<TelemetryPoint>> {
  /// The parameter `request` of this provider.
  AnalyticsChartRequest get request;
}

class _AnalyticsChartProviderElement
    extends AutoDisposeFutureProviderElement<List<TelemetryPoint>>
    with AnalyticsChartRef {
  _AnalyticsChartProviderElement(super.provider);

  @override
  AnalyticsChartRequest get request =>
      (origin as AnalyticsChartProvider).request;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
