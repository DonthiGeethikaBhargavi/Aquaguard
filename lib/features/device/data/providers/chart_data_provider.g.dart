// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chartDataProviderHash() => r'210451905e06211e954499d68c4d3c3c65f0bf93';

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

abstract class _$ChartDataProvider
    extends BuildlessAutoDisposeAsyncNotifier<List<Map<String, dynamic>>> {
  late final String pondId;
  late final String deviceId;
  late final ChartRange range;

  FutureOr<List<Map<String, dynamic>>> build(
    String pondId,
    String deviceId,
    ChartRange range,
  );
}

/// See also [ChartDataProvider].
@ProviderFor(ChartDataProvider)
const chartDataProviderProvider = ChartDataProviderFamily();

/// See also [ChartDataProvider].
class ChartDataProviderFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [ChartDataProvider].
  const ChartDataProviderFamily();

  /// See also [ChartDataProvider].
  ChartDataProviderProvider call(
    String pondId,
    String deviceId,
    ChartRange range,
  ) {
    return ChartDataProviderProvider(pondId, deviceId, range);
  }

  @override
  ChartDataProviderProvider getProviderOverride(
    covariant ChartDataProviderProvider provider,
  ) {
    return call(provider.pondId, provider.deviceId, provider.range);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chartDataProviderProvider';
}

/// See also [ChartDataProvider].
class ChartDataProviderProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ChartDataProvider,
          List<Map<String, dynamic>>
        > {
  /// See also [ChartDataProvider].
  ChartDataProviderProvider(String pondId, String deviceId, ChartRange range)
    : this._internal(
        () => ChartDataProvider()
          ..pondId = pondId
          ..deviceId = deviceId
          ..range = range,
        from: chartDataProviderProvider,
        name: r'chartDataProviderProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chartDataProviderHash,
        dependencies: ChartDataProviderFamily._dependencies,
        allTransitiveDependencies:
            ChartDataProviderFamily._allTransitiveDependencies,
        pondId: pondId,
        deviceId: deviceId,
        range: range,
      );

  ChartDataProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pondId,
    required this.deviceId,
    required this.range,
  }) : super.internal();

  final String pondId;
  final String deviceId;
  final ChartRange range;

  @override
  FutureOr<List<Map<String, dynamic>>> runNotifierBuild(
    covariant ChartDataProvider notifier,
  ) {
    return notifier.build(pondId, deviceId, range);
  }

  @override
  Override overrideWith(ChartDataProvider Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChartDataProviderProvider._internal(
        () => create()
          ..pondId = pondId
          ..deviceId = deviceId
          ..range = range,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pondId: pondId,
        deviceId: deviceId,
        range: range,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    ChartDataProvider,
    List<Map<String, dynamic>>
  >
  createElement() {
    return _ChartDataProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChartDataProviderProvider &&
        other.pondId == pondId &&
        other.deviceId == deviceId &&
        other.range == range;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pondId.hashCode);
    hash = _SystemHash.combine(hash, deviceId.hashCode);
    hash = _SystemHash.combine(hash, range.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChartDataProviderRef
    on AutoDisposeAsyncNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `pondId` of this provider.
  String get pondId;

  /// The parameter `deviceId` of this provider.
  String get deviceId;

  /// The parameter `range` of this provider.
  ChartRange get range;
}

class _ChartDataProviderProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ChartDataProvider,
          List<Map<String, dynamic>>
        >
    with ChartDataProviderRef {
  _ChartDataProviderProviderElement(super.provider);

  @override
  String get pondId => (origin as ChartDataProviderProvider).pondId;
  @override
  String get deviceId => (origin as ChartDataProviderProvider).deviceId;
  @override
  ChartRange get range => (origin as ChartDataProviderProvider).range;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
