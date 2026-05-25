// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_recommendation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$actionRecommendationHash() =>
    r'4278fa3e732cfb410c3137968c60dd77fd640762';

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
/// ACTION RECOMMENDATION PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [actionRecommendation].
@ProviderFor(actionRecommendation)
const actionRecommendationProvider = ActionRecommendationFamily();

////////////////////////////////////////////////////////////
/// ACTION RECOMMENDATION PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [actionRecommendation].
class ActionRecommendationFamily extends Family<AsyncValue<List<ActionItem>>> {
  ////////////////////////////////////////////////////////////
  /// ACTION RECOMMENDATION PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [actionRecommendation].
  const ActionRecommendationFamily();

  ////////////////////////////////////////////////////////////
  /// ACTION RECOMMENDATION PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [actionRecommendation].
  ActionRecommendationProvider call(String pondId, String deviceId) {
    return ActionRecommendationProvider(pondId, deviceId);
  }

  @override
  ActionRecommendationProvider getProviderOverride(
    covariant ActionRecommendationProvider provider,
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
  String? get name => r'actionRecommendationProvider';
}

////////////////////////////////////////////////////////////
/// ACTION RECOMMENDATION PROVIDER
////////////////////////////////////////////////////////////
///
/// Copied from [actionRecommendation].
class ActionRecommendationProvider
    extends AutoDisposeFutureProvider<List<ActionItem>> {
  ////////////////////////////////////////////////////////////
  /// ACTION RECOMMENDATION PROVIDER
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [actionRecommendation].
  ActionRecommendationProvider(String pondId, String deviceId)
    : this._internal(
        (ref) => actionRecommendation(
          ref as ActionRecommendationRef,
          pondId,
          deviceId,
        ),
        from: actionRecommendationProvider,
        name: r'actionRecommendationProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$actionRecommendationHash,
        dependencies: ActionRecommendationFamily._dependencies,
        allTransitiveDependencies:
            ActionRecommendationFamily._allTransitiveDependencies,
        pondId: pondId,
        deviceId: deviceId,
      );

  ActionRecommendationProvider._internal(
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
    FutureOr<List<ActionItem>> Function(ActionRecommendationRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActionRecommendationProvider._internal(
        (ref) => create(ref as ActionRecommendationRef),
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
  AutoDisposeFutureProviderElement<List<ActionItem>> createElement() {
    return _ActionRecommendationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActionRecommendationProvider &&
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
mixin ActionRecommendationRef
    on AutoDisposeFutureProviderRef<List<ActionItem>> {
  /// The parameter `pondId` of this provider.
  String get pondId;

  /// The parameter `deviceId` of this provider.
  String get deviceId;
}

class _ActionRecommendationProviderElement
    extends AutoDisposeFutureProviderElement<List<ActionItem>>
    with ActionRecommendationRef {
  _ActionRecommendationProviderElement(super.provider);

  @override
  String get pondId => (origin as ActionRecommendationProvider).pondId;
  @override
  String get deviceId => (origin as ActionRecommendationProvider).deviceId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
