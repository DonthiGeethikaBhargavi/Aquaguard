// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pond_devices_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pondDevicesHash() => r'06565ce2503d52cb2e571502526eb0f77831c3df';

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

abstract class _$PondDevices
    extends BuildlessAsyncNotifier<List<PondDeviceModel>> {
  late final String pondId;

  FutureOr<List<PondDeviceModel>> build(String pondId);
}

////////////////////////////////////////////////////////////
/// PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [PondDevices].
@ProviderFor(PondDevices)
const pondDevicesProvider = PondDevicesFamily();

////////////////////////////////////////////////////////////
/// PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [PondDevices].
class PondDevicesFamily extends Family<AsyncValue<List<PondDeviceModel>>> {
  ////////////////////////////////////////////////////////////
  /// PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [PondDevices].
  const PondDevicesFamily();

  ////////////////////////////////////////////////////////////
  /// PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [PondDevices].
  PondDevicesProvider call(String pondId) {
    return PondDevicesProvider(pondId);
  }

  @override
  PondDevicesProvider getProviderOverride(
    covariant PondDevicesProvider provider,
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
  String? get name => r'pondDevicesProvider';
}

////////////////////////////////////////////////////////////
/// PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [PondDevices].
class PondDevicesProvider
    extends AsyncNotifierProviderImpl<PondDevices, List<PondDeviceModel>> {
  ////////////////////////////////////////////////////////////
  /// PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [PondDevices].
  PondDevicesProvider(String pondId)
    : this._internal(
        () => PondDevices()..pondId = pondId,
        from: pondDevicesProvider,
        name: r'pondDevicesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$pondDevicesHash,
        dependencies: PondDevicesFamily._dependencies,
        allTransitiveDependencies: PondDevicesFamily._allTransitiveDependencies,
        pondId: pondId,
      );

  PondDevicesProvider._internal(
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
  FutureOr<List<PondDeviceModel>> runNotifierBuild(
    covariant PondDevices notifier,
  ) {
    return notifier.build(pondId);
  }

  @override
  Override overrideWith(PondDevices Function() create) {
    return ProviderOverride(
      origin: this,
      override: PondDevicesProvider._internal(
        () => create()..pondId = pondId,
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
  AsyncNotifierProviderElement<PondDevices, List<PondDeviceModel>>
  createElement() {
    return _PondDevicesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PondDevicesProvider && other.pondId == pondId;
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
mixin PondDevicesRef on AsyncNotifierProviderRef<List<PondDeviceModel>> {
  /// The parameter `pondId` of this provider.
  String get pondId;
}

class _PondDevicesProviderElement
    extends AsyncNotifierProviderElement<PondDevices, List<PondDeviceModel>>
    with PondDevicesRef {
  _PondDevicesProviderElement(super.provider);

  @override
  String get pondId => (origin as PondDevicesProvider).pondId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
