// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_insights_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiInsightsHash() => r'9317140795a2e1e25c9fbf058859d66529a82a23';

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

/// See also [aiInsights].
@ProviderFor(aiInsights)
const aiInsightsProvider = AiInsightsFamily();

/// See also [aiInsights].
class AiInsightsFamily extends Family<AsyncValue<AIInsightsModel>> {
  /// See also [aiInsights].
  const AiInsightsFamily();

  /// See also [aiInsights].
  AiInsightsProvider call(String deviceId) {
    return AiInsightsProvider(deviceId);
  }

  @override
  AiInsightsProvider getProviderOverride(
    covariant AiInsightsProvider provider,
  ) {
    return call(provider.deviceId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'aiInsightsProvider';
}

/// See also [aiInsights].
class AiInsightsProvider extends AutoDisposeStreamProvider<AIInsightsModel> {
  /// See also [aiInsights].
  AiInsightsProvider(String deviceId)
    : this._internal(
        (ref) => aiInsights(ref as AiInsightsRef, deviceId),
        from: aiInsightsProvider,
        name: r'aiInsightsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$aiInsightsHash,
        dependencies: AiInsightsFamily._dependencies,
        allTransitiveDependencies: AiInsightsFamily._allTransitiveDependencies,
        deviceId: deviceId,
      );

  AiInsightsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.deviceId,
  }) : super.internal();

  final String deviceId;

  @override
  Override overrideWith(
    Stream<AIInsightsModel> Function(AiInsightsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AiInsightsProvider._internal(
        (ref) => create(ref as AiInsightsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        deviceId: deviceId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<AIInsightsModel> createElement() {
    return _AiInsightsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AiInsightsProvider && other.deviceId == deviceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, deviceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AiInsightsRef on AutoDisposeStreamProviderRef<AIInsightsModel> {
  /// The parameter `deviceId` of this provider.
  String get deviceId;
}

class _AiInsightsProviderElement
    extends AutoDisposeStreamProviderElement<AIInsightsModel>
    with AiInsightsRef {
  _AiInsightsProviderElement(super.provider);

  @override
  String get deviceId => (origin as AiInsightsProvider).deviceId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
