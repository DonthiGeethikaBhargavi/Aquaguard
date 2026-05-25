// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deviceStatusProviderHash() =>
    r'ce354c304870a56c1fa43755ab7191533e9c042d';

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

abstract class _$DeviceStatusProvider
    extends BuildlessAutoDisposeStreamNotifier<DeviceStatusModel> {
  late final String deviceId;

  Stream<DeviceStatusModel> build(String deviceId);
}

////////////////////////////////////////////////////////////
/// PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [DeviceStatusProvider].
@ProviderFor(DeviceStatusProvider)
const deviceStatusProviderProvider = DeviceStatusProviderFamily();

////////////////////////////////////////////////////////////
/// PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [DeviceStatusProvider].
class DeviceStatusProviderFamily extends Family<AsyncValue<DeviceStatusModel>> {
  ////////////////////////////////////////////////////////////
  /// PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [DeviceStatusProvider].
  const DeviceStatusProviderFamily();

  ////////////////////////////////////////////////////////////
  /// PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [DeviceStatusProvider].
  DeviceStatusProviderProvider call(String deviceId) {
    return DeviceStatusProviderProvider(deviceId);
  }

  @override
  DeviceStatusProviderProvider getProviderOverride(
    covariant DeviceStatusProviderProvider provider,
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
  String? get name => r'deviceStatusProviderProvider';
}

////////////////////////////////////////////////////////////
/// PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [DeviceStatusProvider].
class DeviceStatusProviderProvider
    extends
        AutoDisposeStreamNotifierProviderImpl<
          DeviceStatusProvider,
          DeviceStatusModel
        > {
  ////////////////////////////////////////////////////////////
  /// PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [DeviceStatusProvider].
  DeviceStatusProviderProvider(String deviceId)
    : this._internal(
        () => DeviceStatusProvider()..deviceId = deviceId,
        from: deviceStatusProviderProvider,
        name: r'deviceStatusProviderProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deviceStatusProviderHash,
        dependencies: DeviceStatusProviderFamily._dependencies,
        allTransitiveDependencies:
            DeviceStatusProviderFamily._allTransitiveDependencies,
        deviceId: deviceId,
      );

  DeviceStatusProviderProvider._internal(
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
  Stream<DeviceStatusModel> runNotifierBuild(
    covariant DeviceStatusProvider notifier,
  ) {
    return notifier.build(deviceId);
  }

  @override
  Override overrideWith(DeviceStatusProvider Function() create) {
    return ProviderOverride(
      origin: this,
      override: DeviceStatusProviderProvider._internal(
        () => create()..deviceId = deviceId,
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
  AutoDisposeStreamNotifierProviderElement<
    DeviceStatusProvider,
    DeviceStatusModel
  >
  createElement() {
    return _DeviceStatusProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeviceStatusProviderProvider && other.deviceId == deviceId;
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
mixin DeviceStatusProviderRef
    on AutoDisposeStreamNotifierProviderRef<DeviceStatusModel> {
  /// The parameter `deviceId` of this provider.
  String get deviceId;
}

class _DeviceStatusProviderProviderElement
    extends
        AutoDisposeStreamNotifierProviderElement<
          DeviceStatusProvider,
          DeviceStatusModel
        >
    with DeviceStatusProviderRef {
  _DeviceStatusProviderProviderElement(super.provider);

  @override
  String get deviceId => (origin as DeviceStatusProviderProvider).deviceId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
