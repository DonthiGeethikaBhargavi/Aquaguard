// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_score_calculator_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$healthScoreCalculatorHash() =>
    r'e92a2579f8a85c325f209ef42b8c667710f60c3f';

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
/// HEALTH SCORE PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [healthScoreCalculator].
@ProviderFor(healthScoreCalculator)
const healthScoreCalculatorProvider = HealthScoreCalculatorFamily();

////////////////////////////////////////////////////////////
/// HEALTH SCORE PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [healthScoreCalculator].
class HealthScoreCalculatorFamily
    extends Family<AsyncValue<HealthScoreResult>> {
  ////////////////////////////////////////////////////////////
  /// HEALTH SCORE PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [healthScoreCalculator].
  const HealthScoreCalculatorFamily();

  ////////////////////////////////////////////////////////////
  /// HEALTH SCORE PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [healthScoreCalculator].
  HealthScoreCalculatorProvider call(String pondId, String deviceId) {
    return HealthScoreCalculatorProvider(pondId, deviceId);
  }

  @override
  HealthScoreCalculatorProvider getProviderOverride(
    covariant HealthScoreCalculatorProvider provider,
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
  String? get name => r'healthScoreCalculatorProvider';
}

////////////////////////////////////////////////////////////
/// HEALTH SCORE PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [healthScoreCalculator].
class HealthScoreCalculatorProvider
    extends AutoDisposeFutureProvider<HealthScoreResult> {
  ////////////////////////////////////////////////////////////
  /// HEALTH SCORE PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [healthScoreCalculator].
  HealthScoreCalculatorProvider(String pondId, String deviceId)
    : this._internal(
        (ref) => healthScoreCalculator(
          ref as HealthScoreCalculatorRef,
          pondId,
          deviceId,
        ),
        from: healthScoreCalculatorProvider,
        name: r'healthScoreCalculatorProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$healthScoreCalculatorHash,
        dependencies: HealthScoreCalculatorFamily._dependencies,
        allTransitiveDependencies:
            HealthScoreCalculatorFamily._allTransitiveDependencies,
        pondId: pondId,
        deviceId: deviceId,
      );

  HealthScoreCalculatorProvider._internal(
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
    FutureOr<HealthScoreResult> Function(HealthScoreCalculatorRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HealthScoreCalculatorProvider._internal(
        (ref) => create(ref as HealthScoreCalculatorRef),
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
  AutoDisposeFutureProviderElement<HealthScoreResult> createElement() {
    return _HealthScoreCalculatorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HealthScoreCalculatorProvider &&
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
mixin HealthScoreCalculatorRef
    on AutoDisposeFutureProviderRef<HealthScoreResult> {
  /// The parameter `pondId` of this provider.
  String get pondId;

  /// The parameter `deviceId` of this provider.
  String get deviceId;
}

class _HealthScoreCalculatorProviderElement
    extends AutoDisposeFutureProviderElement<HealthScoreResult>
    with HealthScoreCalculatorRef {
  _HealthScoreCalculatorProviderElement(super.provider);

  @override
  String get pondId => (origin as HealthScoreCalculatorProvider).pondId;
  @override
  String get deviceId => (origin as HealthScoreCalculatorProvider).deviceId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
