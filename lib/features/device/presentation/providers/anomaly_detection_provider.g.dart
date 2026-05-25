// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anomaly_detection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$anomalyDetectionHash() => r'e29ca14d02642e631464600dbd02564ffe8f0fe7';

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
/// ANOMALY DETECTION PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [anomalyDetection].
@ProviderFor(anomalyDetection)
const anomalyDetectionProvider = AnomalyDetectionFamily();

////////////////////////////////////////////////////////////
/// ANOMALY DETECTION PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [anomalyDetection].
class AnomalyDetectionFamily extends Family<AsyncValue<List<AnomalyData>>> {
  ////////////////////////////////////////////////////////////
  /// ANOMALY DETECTION PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [anomalyDetection].
  const AnomalyDetectionFamily();

  ////////////////////////////////////////////////////////////
  /// ANOMALY DETECTION PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [anomalyDetection].
  AnomalyDetectionProvider call(String pondId, String deviceId) {
    return AnomalyDetectionProvider(pondId, deviceId);
  }

  @override
  AnomalyDetectionProvider getProviderOverride(
    covariant AnomalyDetectionProvider provider,
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
  String? get name => r'anomalyDetectionProvider';
}

////////////////////////////////////////////////////////////
/// ANOMALY DETECTION PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [anomalyDetection].
class AnomalyDetectionProvider
    extends AutoDisposeFutureProvider<List<AnomalyData>> {
  ////////////////////////////////////////////////////////////
  /// ANOMALY DETECTION PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [anomalyDetection].
  AnomalyDetectionProvider(String pondId, String deviceId)
    : this._internal(
        (ref) => anomalyDetection(ref as AnomalyDetectionRef, pondId, deviceId),
        from: anomalyDetectionProvider,
        name: r'anomalyDetectionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$anomalyDetectionHash,
        dependencies: AnomalyDetectionFamily._dependencies,
        allTransitiveDependencies:
            AnomalyDetectionFamily._allTransitiveDependencies,
        pondId: pondId,
        deviceId: deviceId,
      );

  AnomalyDetectionProvider._internal(
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
    FutureOr<List<AnomalyData>> Function(AnomalyDetectionRef provider) create,
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
        deviceId: deviceId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AnomalyData>> createElement() {
    return _AnomalyDetectionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AnomalyDetectionProvider &&
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
mixin AnomalyDetectionRef on AutoDisposeFutureProviderRef<List<AnomalyData>> {
  /// The parameter `pondId` of this provider.
  String get pondId;

  /// The parameter `deviceId` of this provider.
  String get deviceId;
}

class _AnomalyDetectionProviderElement
    extends AutoDisposeFutureProviderElement<List<AnomalyData>>
    with AnomalyDetectionRef {
  _AnomalyDetectionProviderElement(super.provider);

  @override
  String get pondId => (origin as AnomalyDetectionProvider).pondId;
  @override
  String get deviceId => (origin as AnomalyDetectionProvider).deviceId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
