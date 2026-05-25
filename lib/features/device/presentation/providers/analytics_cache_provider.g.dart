// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_cache_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loadCachedAnalyticsHash() =>
    r'09b9a439164fb22ade017577ca24b6dee0ab3db2';

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
/// LOAD CACHED ANALYTICS
////////////////////////////////////////////////////////////
///
/// Copied from [loadCachedAnalytics].
@ProviderFor(loadCachedAnalytics)
const loadCachedAnalyticsProvider = LoadCachedAnalyticsFamily();

////////////////////////////////////////////////////////////
/// LOAD CACHED ANALYTICS
////////////////////////////////////////////////////////////
///
/// Copied from [loadCachedAnalytics].
class LoadCachedAnalyticsFamily
    extends Family<AsyncValue<Map<String, dynamic>?>> {
  ////////////////////////////////////////////////////////////
  /// LOAD CACHED ANALYTICS
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [loadCachedAnalytics].
  const LoadCachedAnalyticsFamily();

  ////////////////////////////////////////////////////////////
  /// LOAD CACHED ANALYTICS
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [loadCachedAnalytics].
  LoadCachedAnalyticsProvider call(String pondId, String deviceId) {
    return LoadCachedAnalyticsProvider(pondId, deviceId);
  }

  @override
  LoadCachedAnalyticsProvider getProviderOverride(
    covariant LoadCachedAnalyticsProvider provider,
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
  String? get name => r'loadCachedAnalyticsProvider';
}

////////////////////////////////////////////////////////////
/// LOAD CACHED ANALYTICS
////////////////////////////////////////////////////////////
///
/// Copied from [loadCachedAnalytics].
class LoadCachedAnalyticsProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>?> {
  ////////////////////////////////////////////////////////////
  /// LOAD CACHED ANALYTICS
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [loadCachedAnalytics].
  LoadCachedAnalyticsProvider(String pondId, String deviceId)
    : this._internal(
        (ref) => loadCachedAnalytics(
          ref as LoadCachedAnalyticsRef,
          pondId,
          deviceId,
        ),
        from: loadCachedAnalyticsProvider,
        name: r'loadCachedAnalyticsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$loadCachedAnalyticsHash,
        dependencies: LoadCachedAnalyticsFamily._dependencies,
        allTransitiveDependencies:
            LoadCachedAnalyticsFamily._allTransitiveDependencies,
        pondId: pondId,
        deviceId: deviceId,
      );

  LoadCachedAnalyticsProvider._internal(
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
    FutureOr<Map<String, dynamic>?> Function(LoadCachedAnalyticsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LoadCachedAnalyticsProvider._internal(
        (ref) => create(ref as LoadCachedAnalyticsRef),
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
  AutoDisposeFutureProviderElement<Map<String, dynamic>?> createElement() {
    return _LoadCachedAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadCachedAnalyticsProvider &&
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
mixin LoadCachedAnalyticsRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>?> {
  /// The parameter `pondId` of this provider.
  String get pondId;

  /// The parameter `deviceId` of this provider.
  String get deviceId;
}

class _LoadCachedAnalyticsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>?>
    with LoadCachedAnalyticsRef {
  _LoadCachedAnalyticsProviderElement(super.provider);

  @override
  String get pondId => (origin as LoadCachedAnalyticsProvider).pondId;
  @override
  String get deviceId => (origin as LoadCachedAnalyticsProvider).deviceId;
}

String _$saveAnalyticsToCacheHash() =>
    r'332c289c862bb05238f2358e0e7a6afd51103cf0';

////////////////////////////////////////////////////////////
/// SAVE ANALYTICS TO CACHE
////////////////////////////////////////////////////////////
///
/// Copied from [saveAnalyticsToCache].
@ProviderFor(saveAnalyticsToCache)
const saveAnalyticsToCacheProvider = SaveAnalyticsToCacheFamily();

////////////////////////////////////////////////////////////
/// SAVE ANALYTICS TO CACHE
////////////////////////////////////////////////////////////
///
/// Copied from [saveAnalyticsToCache].
class SaveAnalyticsToCacheFamily extends Family<AsyncValue<void>> {
  ////////////////////////////////////////////////////////////
  /// SAVE ANALYTICS TO CACHE
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [saveAnalyticsToCache].
  const SaveAnalyticsToCacheFamily();

  ////////////////////////////////////////////////////////////
  /// SAVE ANALYTICS TO CACHE
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [saveAnalyticsToCache].
  SaveAnalyticsToCacheProvider call(
    String pondId,
    String deviceId,
    Map<String, dynamic> analyticsData,
  ) {
    return SaveAnalyticsToCacheProvider(pondId, deviceId, analyticsData);
  }

  @override
  SaveAnalyticsToCacheProvider getProviderOverride(
    covariant SaveAnalyticsToCacheProvider provider,
  ) {
    return call(provider.pondId, provider.deviceId, provider.analyticsData);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'saveAnalyticsToCacheProvider';
}

////////////////////////////////////////////////////////////
/// SAVE ANALYTICS TO CACHE
////////////////////////////////////////////////////////////
///
/// Copied from [saveAnalyticsToCache].
class SaveAnalyticsToCacheProvider extends AutoDisposeFutureProvider<void> {
  ////////////////////////////////////////////////////////////
  /// SAVE ANALYTICS TO CACHE
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [saveAnalyticsToCache].
  SaveAnalyticsToCacheProvider(
    String pondId,
    String deviceId,
    Map<String, dynamic> analyticsData,
  ) : this._internal(
        (ref) => saveAnalyticsToCache(
          ref as SaveAnalyticsToCacheRef,
          pondId,
          deviceId,
          analyticsData,
        ),
        from: saveAnalyticsToCacheProvider,
        name: r'saveAnalyticsToCacheProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$saveAnalyticsToCacheHash,
        dependencies: SaveAnalyticsToCacheFamily._dependencies,
        allTransitiveDependencies:
            SaveAnalyticsToCacheFamily._allTransitiveDependencies,
        pondId: pondId,
        deviceId: deviceId,
        analyticsData: analyticsData,
      );

  SaveAnalyticsToCacheProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pondId,
    required this.deviceId,
    required this.analyticsData,
  }) : super.internal();

  final String pondId;
  final String deviceId;
  final Map<String, dynamic> analyticsData;

  @override
  Override overrideWith(
    FutureOr<void> Function(SaveAnalyticsToCacheRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SaveAnalyticsToCacheProvider._internal(
        (ref) => create(ref as SaveAnalyticsToCacheRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pondId: pondId,
        deviceId: deviceId,
        analyticsData: analyticsData,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SaveAnalyticsToCacheProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SaveAnalyticsToCacheProvider &&
        other.pondId == pondId &&
        other.deviceId == deviceId &&
        other.analyticsData == analyticsData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pondId.hashCode);
    hash = _SystemHash.combine(hash, deviceId.hashCode);
    hash = _SystemHash.combine(hash, analyticsData.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SaveAnalyticsToCacheRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `pondId` of this provider.
  String get pondId;

  /// The parameter `deviceId` of this provider.
  String get deviceId;

  /// The parameter `analyticsData` of this provider.
  Map<String, dynamic> get analyticsData;
}

class _SaveAnalyticsToCacheProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with SaveAnalyticsToCacheRef {
  _SaveAnalyticsToCacheProviderElement(super.provider);

  @override
  String get pondId => (origin as SaveAnalyticsToCacheProvider).pondId;
  @override
  String get deviceId => (origin as SaveAnalyticsToCacheProvider).deviceId;
  @override
  Map<String, dynamic> get analyticsData =>
      (origin as SaveAnalyticsToCacheProvider).analyticsData;
}

String _$clearAnalyticsCacheHash() =>
    r'3f06093612d72520f526c87a96418ac78c2f939e'; ////////////////////////////////////////////////////////////
/// CLEAR ANALYTICS CACHE
////////////////////////////////////////////////////////////
///
/// Copied from [clearAnalyticsCache].
@ProviderFor(clearAnalyticsCache)
final clearAnalyticsCacheProvider = AutoDisposeFutureProvider<void>.internal(
  clearAnalyticsCache,
  name: r'clearAnalyticsCacheProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$clearAnalyticsCacheHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ClearAnalyticsCacheRef = AutoDisposeFutureProviderRef<void>;
String _$isCacheValidHash() => r'9bd3e2856aec7023ae5a18cef13ee51dd7086123';

////////////////////////////////////////////////////////////
/// CHECK CACHE VALIDITY
////////////////////////////////////////////////////////////
///
/// Copied from [isCacheValid].
@ProviderFor(isCacheValid)
const isCacheValidProvider = IsCacheValidFamily();

////////////////////////////////////////////////////////////
/// CHECK CACHE VALIDITY
////////////////////////////////////////////////////////////
///
/// Copied from [isCacheValid].
class IsCacheValidFamily extends Family<AsyncValue<bool>> {
  ////////////////////////////////////////////////////////////
  /// CHECK CACHE VALIDITY
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [isCacheValid].
  const IsCacheValidFamily();

  ////////////////////////////////////////////////////////////
  /// CHECK CACHE VALIDITY
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [isCacheValid].
  IsCacheValidProvider call(String pondId, String deviceId) {
    return IsCacheValidProvider(pondId, deviceId);
  }

  @override
  IsCacheValidProvider getProviderOverride(
    covariant IsCacheValidProvider provider,
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
  String? get name => r'isCacheValidProvider';
}

////////////////////////////////////////////////////////////
/// CHECK CACHE VALIDITY
////////////////////////////////////////////////////////////
///
/// Copied from [isCacheValid].
class IsCacheValidProvider extends AutoDisposeFutureProvider<bool> {
  ////////////////////////////////////////////////////////////
  /// CHECK CACHE VALIDITY
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [isCacheValid].
  IsCacheValidProvider(String pondId, String deviceId)
    : this._internal(
        (ref) => isCacheValid(ref as IsCacheValidRef, pondId, deviceId),
        from: isCacheValidProvider,
        name: r'isCacheValidProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$isCacheValidHash,
        dependencies: IsCacheValidFamily._dependencies,
        allTransitiveDependencies:
            IsCacheValidFamily._allTransitiveDependencies,
        pondId: pondId,
        deviceId: deviceId,
      );

  IsCacheValidProvider._internal(
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
    FutureOr<bool> Function(IsCacheValidRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsCacheValidProvider._internal(
        (ref) => create(ref as IsCacheValidRef),
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
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _IsCacheValidProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsCacheValidProvider &&
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
mixin IsCacheValidRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `pondId` of this provider.
  String get pondId;

  /// The parameter `deviceId` of this provider.
  String get deviceId;
}

class _IsCacheValidProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with IsCacheValidRef {
  _IsCacheValidProviderElement(super.provider);

  @override
  String get pondId => (origin as IsCacheValidProvider).pondId;
  @override
  String get deviceId => (origin as IsCacheValidProvider).deviceId;
}

String _$getCacheAgeHash() => r'bb1ad8a9a3056a2c0e1f1c9753324431be202505';

////////////////////////////////////////////////////////////
/// GET CACHE AGE
////////////////////////////////////////////////////////////
///
/// Copied from [getCacheAge].
@ProviderFor(getCacheAge)
const getCacheAgeProvider = GetCacheAgeFamily();

////////////////////////////////////////////////////////////
/// GET CACHE AGE
////////////////////////////////////////////////////////////
///
/// Copied from [getCacheAge].
class GetCacheAgeFamily extends Family<AsyncValue<int?>> {
  ////////////////////////////////////////////////////////////
  /// GET CACHE AGE
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [getCacheAge].
  const GetCacheAgeFamily();

  ////////////////////////////////////////////////////////////
  /// GET CACHE AGE
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [getCacheAge].
  GetCacheAgeProvider call(String pondId, String deviceId) {
    return GetCacheAgeProvider(pondId, deviceId);
  }

  @override
  GetCacheAgeProvider getProviderOverride(
    covariant GetCacheAgeProvider provider,
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
  String? get name => r'getCacheAgeProvider';
}

////////////////////////////////////////////////////////////
/// GET CACHE AGE
////////////////////////////////////////////////////////////
///
/// Copied from [getCacheAge].
class GetCacheAgeProvider extends AutoDisposeFutureProvider<int?> {
  ////////////////////////////////////////////////////////////
  /// GET CACHE AGE
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [getCacheAge].
  GetCacheAgeProvider(String pondId, String deviceId)
    : this._internal(
        (ref) => getCacheAge(ref as GetCacheAgeRef, pondId, deviceId),
        from: getCacheAgeProvider,
        name: r'getCacheAgeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getCacheAgeHash,
        dependencies: GetCacheAgeFamily._dependencies,
        allTransitiveDependencies: GetCacheAgeFamily._allTransitiveDependencies,
        pondId: pondId,
        deviceId: deviceId,
      );

  GetCacheAgeProvider._internal(
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
    FutureOr<int?> Function(GetCacheAgeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetCacheAgeProvider._internal(
        (ref) => create(ref as GetCacheAgeRef),
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
  AutoDisposeFutureProviderElement<int?> createElement() {
    return _GetCacheAgeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCacheAgeProvider &&
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
mixin GetCacheAgeRef on AutoDisposeFutureProviderRef<int?> {
  /// The parameter `pondId` of this provider.
  String get pondId;

  /// The parameter `deviceId` of this provider.
  String get deviceId;
}

class _GetCacheAgeProviderElement extends AutoDisposeFutureProviderElement<int?>
    with GetCacheAgeRef {
  _GetCacheAgeProviderElement(super.provider);

  @override
  String get pondId => (origin as GetCacheAgeProvider).pondId;
  @override
  String get deviceId => (origin as GetCacheAgeProvider).deviceId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
