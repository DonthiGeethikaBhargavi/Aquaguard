// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anomaly_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$anomalyDetectionHash() => r'58c786c6aeef3fcbef2b972cce3bbfaa9d94d1df';

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

/// See also [anomalyDetection].
@ProviderFor(anomalyDetection)
const anomalyDetectionProvider = AnomalyDetectionFamily();

/// See also [anomalyDetection].
class AnomalyDetectionFamily extends Family<AsyncValue<List<AnomalyModel>>> {
  /// See also [anomalyDetection].
  const AnomalyDetectionFamily();

  /// See also [anomalyDetection].
  AnomalyDetectionProvider call(String pondId) {
    return AnomalyDetectionProvider(pondId);
  }

  @override
  AnomalyDetectionProvider getProviderOverride(
    covariant AnomalyDetectionProvider provider,
  ) {
    return call(provider.pondId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'anomalyDetectionProvider';
}

/// See also [anomalyDetection].
class AnomalyDetectionProvider
    extends AutoDisposeFutureProvider<List<AnomalyModel>> {
  /// See also [anomalyDetection].
  AnomalyDetectionProvider(String pondId)
    : this._internal(
        (ref) => anomalyDetection(ref as AnomalyDetectionRef, pondId),
        from: anomalyDetectionProvider,
        name: r'anomalyDetectionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$anomalyDetectionHash,
        dependencies: AnomalyDetectionFamily._dependencies,
        allTransitiveDependencies:
            AnomalyDetectionFamily._allTransitiveDependencies,
        pondId: pondId,
      );

  AnomalyDetectionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pondId,
  }) : super.internal();

  final String pondId;

  @override
  Override overrideWith(
    FutureOr<List<AnomalyModel>> Function(AnomalyDetectionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AnomalyDetectionProvider._internal(
        (ref) => create(ref as AnomalyDetectionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pondId: pondId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AnomalyModel>> createElement() {
    return _AnomalyDetectionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AnomalyDetectionProvider && other.pondId == pondId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pondId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AnomalyDetectionRef on AutoDisposeFutureProviderRef<List<AnomalyModel>> {
  /// The parameter `pondId` of this provider.
  String get pondId;
}

class _AnomalyDetectionProviderElement
    extends AutoDisposeFutureProviderElement<List<AnomalyModel>>
    with AnomalyDetectionRef {
  _AnomalyDetectionProviderElement(super.provider);

  @override
  String get pondId => (origin as AnomalyDetectionProvider).pondId;
}

String _$anomalyTimelineHash() => r'0a9f429b2434f17dfd36f39a8c793993183a166d';

/// See also [anomalyTimeline].
@ProviderFor(anomalyTimeline)
const anomalyTimelineProvider = AnomalyTimelineFamily();

/// See also [anomalyTimeline].
class AnomalyTimelineFamily extends Family<AsyncValue<List<AnomalyModel>>> {
  /// See also [anomalyTimeline].
  const AnomalyTimelineFamily();

  /// See also [anomalyTimeline].
  AnomalyTimelineProvider call(String pondId) {
    return AnomalyTimelineProvider(pondId);
  }

  @override
  AnomalyTimelineProvider getProviderOverride(
    covariant AnomalyTimelineProvider provider,
  ) {
    return call(provider.pondId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'anomalyTimelineProvider';
}

/// See also [anomalyTimeline].
class AnomalyTimelineProvider
    extends AutoDisposeStreamProvider<List<AnomalyModel>> {
  /// See also [anomalyTimeline].
  AnomalyTimelineProvider(String pondId)
    : this._internal(
        (ref) => anomalyTimeline(ref as AnomalyTimelineRef, pondId),
        from: anomalyTimelineProvider,
        name: r'anomalyTimelineProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$anomalyTimelineHash,
        dependencies: AnomalyTimelineFamily._dependencies,
        allTransitiveDependencies:
            AnomalyTimelineFamily._allTransitiveDependencies,
        pondId: pondId,
      );

  AnomalyTimelineProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pondId,
  }) : super.internal();

  final String pondId;

  @override
  Override overrideWith(
    Stream<List<AnomalyModel>> Function(AnomalyTimelineRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AnomalyTimelineProvider._internal(
        (ref) => create(ref as AnomalyTimelineRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pondId: pondId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<AnomalyModel>> createElement() {
    return _AnomalyTimelineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AnomalyTimelineProvider && other.pondId == pondId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pondId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AnomalyTimelineRef on AutoDisposeStreamProviderRef<List<AnomalyModel>> {
  /// The parameter `pondId` of this provider.
  String get pondId;
}

class _AnomalyTimelineProviderElement
    extends AutoDisposeStreamProviderElement<List<AnomalyModel>>
    with AnomalyTimelineRef {
  _AnomalyTimelineProviderElement(super.provider);

  @override
  String get pondId => (origin as AnomalyTimelineProvider).pondId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
