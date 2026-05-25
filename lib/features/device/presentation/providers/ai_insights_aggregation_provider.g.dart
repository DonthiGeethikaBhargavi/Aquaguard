// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_insights_aggregation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiInsightsAggregationHash() =>
    r'3e6f765660b30eaffa9c801f8ae4277f7d96fd5c';

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
/// AI INSIGHTS AGGREGATION PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [aiInsightsAggregation].
@ProviderFor(aiInsightsAggregation)
const aiInsightsAggregationProvider = AiInsightsAggregationFamily();

////////////////////////////////////////////////////////////
/// AI INSIGHTS AGGREGATION PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [aiInsightsAggregation].
class AiInsightsAggregationFamily extends Family<AsyncValue<List<AiInsight>>> {
  ////////////////////////////////////////////////////////////
  /// AI INSIGHTS AGGREGATION PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [aiInsightsAggregation].
  const AiInsightsAggregationFamily();

  ////////////////////////////////////////////////////////////
  /// AI INSIGHTS AGGREGATION PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [aiInsightsAggregation].
  AiInsightsAggregationProvider call(String pondId, String deviceId) {
    return AiInsightsAggregationProvider(pondId, deviceId);
  }

  @override
  AiInsightsAggregationProvider getProviderOverride(
    covariant AiInsightsAggregationProvider provider,
  ) {
    return call(provider.pondId, provider.deviceId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'aiInsightsAggregationProvider';
}

////////////////////////////////////////////////////////////
/// AI INSIGHTS AGGREGATION PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [aiInsightsAggregation].
class AiInsightsAggregationProvider
    extends AutoDisposeFutureProvider<List<AiInsight>> {
  ////////////////////////////////////////////////////////////
  /// AI INSIGHTS AGGREGATION PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [aiInsightsAggregation].
  AiInsightsAggregationProvider(String pondId, String deviceId)
    : this._internal(
        (ref) => aiInsightsAggregation(
          ref as AiInsightsAggregationRef,
          pondId,
          deviceId,
        ),
        from: aiInsightsAggregationProvider,
        name: r'aiInsightsAggregationProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$aiInsightsAggregationHash,
        dependencies: AiInsightsAggregationFamily._dependencies,
        allTransitiveDependencies:
            AiInsightsAggregationFamily._allTransitiveDependencies,
        pondId: pondId,
        deviceId: deviceId,
      );

  AiInsightsAggregationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pondId,
    required this.deviceId,
  }) : super.internal();

  final String pondId;
  final String deviceId;

  @override
  Override overrideWith(
    FutureOr<List<AiInsight>> Function(AiInsightsAggregationRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AiInsightsAggregationProvider._internal(
        (ref) => create(ref as AiInsightsAggregationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pondId: pondId,
        deviceId: deviceId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AiInsight>> createElement() {
    return _AiInsightsAggregationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AiInsightsAggregationProvider &&
        other.pondId == pondId &&
        other.deviceId == deviceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pondId.hashCode);
    hash = _SystemHash.combine(hash, deviceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AiInsightsAggregationRef
    on AutoDisposeFutureProviderRef<List<AiInsight>> {
  /// The parameter `pondId` of this provider.
  String get pondId;

  /// The parameter `deviceId` of this provider.
  String get deviceId;
}

class _AiInsightsAggregationProviderElement
    extends AutoDisposeFutureProviderElement<List<AiInsight>>
    with AiInsightsAggregationRef {
  _AiInsightsAggregationProviderElement(super.provider);

  @override
  String get pondId => (origin as AiInsightsAggregationProvider).pondId;
  @override
  String get deviceId => (origin as AiInsightsAggregationProvider).deviceId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
