// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alerts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$alertsProviderHash() => r'3b7bccbcf4d402a461e18545fed4bc6d4d646e08';

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

/// See also [alertsProvider].
@ProviderFor(alertsProvider)
const alertsProviderProvider = AlertsProviderFamily();

/// See also [alertsProvider].
class AlertsProviderFamily extends Family<AsyncValue<List<AlertModel>>> {
  /// See also [alertsProvider].
  const AlertsProviderFamily();

  /// See also [alertsProvider].
  AlertsProviderProvider call(String pondId, String deviceId) {
    return AlertsProviderProvider(pondId, deviceId);
  }

  @override
  AlertsProviderProvider getProviderOverride(
    covariant AlertsProviderProvider provider,
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
  String? get name => r'alertsProviderProvider';
}

/// See also [alertsProvider].
class AlertsProviderProvider
    extends AutoDisposeFutureProvider<List<AlertModel>> {
  /// See also [alertsProvider].
  AlertsProviderProvider(String pondId, String deviceId)
    : this._internal(
        (ref) => alertsProvider(ref as AlertsProviderRef, pondId, deviceId),
        from: alertsProviderProvider,
        name: r'alertsProviderProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$alertsProviderHash,
        dependencies: AlertsProviderFamily._dependencies,
        allTransitiveDependencies:
            AlertsProviderFamily._allTransitiveDependencies,
        pondId: pondId,
        deviceId: deviceId,
      );

  AlertsProviderProvider._internal(
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
    FutureOr<List<AlertModel>> Function(AlertsProviderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AlertsProviderProvider._internal(
        (ref) => create(ref as AlertsProviderRef),
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
  AutoDisposeFutureProviderElement<List<AlertModel>> createElement() {
    return _AlertsProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AlertsProviderProvider &&
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
mixin AlertsProviderRef on AutoDisposeFutureProviderRef<List<AlertModel>> {
  /// The parameter `pondId` of this provider.
  String get pondId;

  /// The parameter `deviceId` of this provider.
  String get deviceId;
}

class _AlertsProviderProviderElement
    extends AutoDisposeFutureProviderElement<List<AlertModel>>
    with AlertsProviderRef {
  _AlertsProviderProviderElement(super.provider);

  @override
  String get pondId => (origin as AlertsProviderProvider).pondId;
  @override
  String get deviceId => (origin as AlertsProviderProvider).deviceId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
