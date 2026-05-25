// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction_engine_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$predictionEngineHash() => r'30776027675fa5cae521e9ffadb1f6cd86a36d66';

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
/// PREDICTION ENGINE PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [predictionEngine].
@ProviderFor(predictionEngine)
const predictionEngineProvider = PredictionEngineFamily();

////////////////////////////////////////////////////////////
/// PREDICTION ENGINE PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [predictionEngine].
class PredictionEngineFamily extends Family<AsyncValue<List<PredictionData>>> {
  ////////////////////////////////////////////////////////////
  /// PREDICTION ENGINE PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [predictionEngine].
  const PredictionEngineFamily();

  ////////////////////////////////////////////////////////////
  /// PREDICTION ENGINE PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [predictionEngine].
  PredictionEngineProvider call(String pondId, String deviceId) {
    return PredictionEngineProvider(pondId, deviceId);
  }

  @override
  PredictionEngineProvider getProviderOverride(
    covariant PredictionEngineProvider provider,
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
  String? get name => r'predictionEngineProvider';
}

////////////////////////////////////////////////////////////
/// PREDICTION ENGINE PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [predictionEngine].
class PredictionEngineProvider
    extends AutoDisposeFutureProvider<List<PredictionData>> {
  ////////////////////////////////////////////////////////////
  /// PREDICTION ENGINE PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [predictionEngine].
  PredictionEngineProvider(String pondId, String deviceId)
    : this._internal(
        (ref) => predictionEngine(ref as PredictionEngineRef, pondId, deviceId),
        from: predictionEngineProvider,
        name: r'predictionEngineProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$predictionEngineHash,
        dependencies: PredictionEngineFamily._dependencies,
        allTransitiveDependencies:
            PredictionEngineFamily._allTransitiveDependencies,
        pondId: pondId,
        deviceId: deviceId,
      );

  PredictionEngineProvider._internal(
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
    FutureOr<List<PredictionData>> Function(PredictionEngineRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PredictionEngineProvider._internal(
        (ref) => create(ref as PredictionEngineRef),
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
  AutoDisposeFutureProviderElement<List<PredictionData>> createElement() {
    return _PredictionEngineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PredictionEngineProvider &&
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
mixin PredictionEngineRef
    on AutoDisposeFutureProviderRef<List<PredictionData>> {
  /// The parameter `pondId` of this provider.
  String get pondId;

  /// The parameter `deviceId` of this provider.
  String get deviceId;
}

class _PredictionEngineProviderElement
    extends AutoDisposeFutureProviderElement<List<PredictionData>>
    with PredictionEngineRef {
  _PredictionEngineProviderElement(super.provider);

  @override
  String get pondId => (origin as PredictionEngineProvider).pondId;
  @override
  String get deviceId => (origin as PredictionEngineProvider).deviceId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
