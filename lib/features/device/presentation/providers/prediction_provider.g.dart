// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$predictionEngineHash() => r'64c4aa54c0f6493c10e86025a75886e7a92b3259';

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

/// See also [predictionEngine].
@ProviderFor(predictionEngine)
const predictionEngineProvider = PredictionEngineFamily();

/// See also [predictionEngine].
class PredictionEngineFamily extends Family<AsyncValue<List<PredictionModel>>> {
  /// See also [predictionEngine].
  const PredictionEngineFamily();

  /// See also [predictionEngine].
  PredictionEngineProvider call(PredictionRequest request) {
    return PredictionEngineProvider(request);
  }

  @override
  PredictionEngineProvider getProviderOverride(
    covariant PredictionEngineProvider provider,
  ) {
    return call(provider.request);
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

/// See also [predictionEngine].
class PredictionEngineProvider
    extends AutoDisposeFutureProvider<List<PredictionModel>> {
  /// See also [predictionEngine].
  PredictionEngineProvider(PredictionRequest request)
    : this._internal(
        (ref) => predictionEngine(ref as PredictionEngineRef, request),
        from: predictionEngineProvider,
        name: r'predictionEngineProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$predictionEngineHash,
        dependencies: PredictionEngineFamily._dependencies,
        allTransitiveDependencies:
            PredictionEngineFamily._allTransitiveDependencies,
        request: request,
      );

  PredictionEngineProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.request,
  }) : super.internal();

  final PredictionRequest request;

  @override
  Override overrideWith(
    FutureOr<List<PredictionModel>> Function(PredictionEngineRef provider)
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
        request: request,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PredictionModel>> createElement() {
    return _PredictionEngineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PredictionEngineProvider && other.request == request;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, request.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PredictionEngineRef
    on AutoDisposeFutureProviderRef<List<PredictionModel>> {
  /// The parameter `request` of this provider.
  PredictionRequest get request;
}

class _PredictionEngineProviderElement
    extends AutoDisposeFutureProviderElement<List<PredictionModel>>
    with PredictionEngineRef {
  _PredictionEngineProviderElement(super.provider);

  @override
  PredictionRequest get request => (origin as PredictionEngineProvider).request;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
