// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_reading_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sensorReadingProviderHash() =>
    r'24f1432e2b66a861b7a4dc2c7c64fa68f51f0830';

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

/// See also [sensorReadingProvider].
@ProviderFor(sensorReadingProvider)
const sensorReadingProviderProvider = SensorReadingProviderFamily();

/// See also [sensorReadingProvider].
class SensorReadingProviderFamily
    extends Family<AsyncValue<SensorReadingModel?>> {
  /// See also [sensorReadingProvider].
  const SensorReadingProviderFamily();

  /// See also [sensorReadingProvider].
  SensorReadingProviderProvider call(String pondId, String deviceId) {
    return SensorReadingProviderProvider(pondId, deviceId);
  }

  @override
  SensorReadingProviderProvider getProviderOverride(
    covariant SensorReadingProviderProvider provider,
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
  String? get name => r'sensorReadingProviderProvider';
}

/// See also [sensorReadingProvider].
class SensorReadingProviderProvider
    extends AutoDisposeFutureProvider<SensorReadingModel?> {
  /// See also [sensorReadingProvider].
  SensorReadingProviderProvider(String pondId, String deviceId)
    : this._internal(
        (ref) => sensorReadingProvider(
          ref as SensorReadingProviderRef,
          pondId,
          deviceId,
        ),
        from: sensorReadingProviderProvider,
        name: r'sensorReadingProviderProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sensorReadingProviderHash,
        dependencies: SensorReadingProviderFamily._dependencies,
        allTransitiveDependencies:
            SensorReadingProviderFamily._allTransitiveDependencies,
        pondId: pondId,
        deviceId: deviceId,
      );

  SensorReadingProviderProvider._internal(
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
    FutureOr<SensorReadingModel?> Function(SensorReadingProviderRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SensorReadingProviderProvider._internal(
        (ref) => create(ref as SensorReadingProviderRef),
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
  AutoDisposeFutureProviderElement<SensorReadingModel?> createElement() {
    return _SensorReadingProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SensorReadingProviderProvider &&
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
mixin SensorReadingProviderRef
    on AutoDisposeFutureProviderRef<SensorReadingModel?> {
  /// The parameter `pondId` of this provider.
  String get pondId;

  /// The parameter `deviceId` of this provider.
  String get deviceId;
}

class _SensorReadingProviderProviderElement
    extends AutoDisposeFutureProviderElement<SensorReadingModel?>
    with SensorReadingProviderRef {
  _SensorReadingProviderProviderElement(super.provider);

  @override
  String get pondId => (origin as SensorReadingProviderProvider).pondId;
  @override
  String get deviceId => (origin as SensorReadingProviderProvider).deviceId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
