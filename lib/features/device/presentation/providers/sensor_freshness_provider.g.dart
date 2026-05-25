// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_freshness_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sensorFreshnessHash() => r'4911847337708522857141fc1275f3c1a3fda9f6';

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
/// SENSOR FRESHNESS PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [sensorFreshness].
@ProviderFor(sensorFreshness)
const sensorFreshnessProvider = SensorFreshnessFamily();

////////////////////////////////////////////////////////////
/// SENSOR FRESHNESS PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [sensorFreshness].
class SensorFreshnessFamily extends Family<AsyncValue<SensorFreshnessResult>> {
  ////////////////////////////////////////////////////////////
  /// SENSOR FRESHNESS PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [sensorFreshness].
  const SensorFreshnessFamily();

  ////////////////////////////////////////////////////////////
  /// SENSOR FRESHNESS PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [sensorFreshness].
  SensorFreshnessProvider call(String deviceId) {
    return SensorFreshnessProvider(deviceId);
  }

  @override
  SensorFreshnessProvider getProviderOverride(
    covariant SensorFreshnessProvider provider,
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
  String? get name => r'sensorFreshnessProvider';
}

////////////////////////////////////////////////////////////
/// SENSOR FRESHNESS PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [sensorFreshness].
class SensorFreshnessProvider
    extends AutoDisposeFutureProvider<SensorFreshnessResult> {
  ////////////////////////////////////////////////////////////
  /// SENSOR FRESHNESS PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [sensorFreshness].
  SensorFreshnessProvider(String deviceId)
    : this._internal(
        (ref) => sensorFreshness(ref as SensorFreshnessRef, deviceId),
        from: sensorFreshnessProvider,
        name: r'sensorFreshnessProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sensorFreshnessHash,
        dependencies: SensorFreshnessFamily._dependencies,
        allTransitiveDependencies:
            SensorFreshnessFamily._allTransitiveDependencies,
        deviceId: deviceId,
      );

  SensorFreshnessProvider._internal(
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
    FutureOr<SensorFreshnessResult> Function(SensorFreshnessRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SensorFreshnessProvider._internal(
        (ref) => create(ref as SensorFreshnessRef),
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
  AutoDisposeFutureProviderElement<SensorFreshnessResult> createElement() {
    return _SensorFreshnessProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SensorFreshnessProvider && other.deviceId == deviceId;
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
mixin SensorFreshnessRef
    on AutoDisposeFutureProviderRef<SensorFreshnessResult> {
  /// The parameter `deviceId` of this provider.
  String get deviceId;
}

class _SensorFreshnessProviderElement
    extends AutoDisposeFutureProviderElement<SensorFreshnessResult>
    with SensorFreshnessRef {
  _SensorFreshnessProviderElement(super.provider);

  @override
  String get deviceId => (origin as SensorFreshnessProvider).deviceId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
