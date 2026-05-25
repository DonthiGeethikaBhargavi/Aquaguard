// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$telemetryChartHash() => r'0944fc019505ee83e2cb4d59287d7e88d95b9a5f';

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
/// TELEMETRY CHART
////////////////////////////////////////////////////////////
///
/// Copied from [telemetryChart].
@ProviderFor(telemetryChart)
const telemetryChartProvider = TelemetryChartFamily();

////////////////////////////////////////////////////////////
/// TELEMETRY CHART
////////////////////////////////////////////////////////////
///
/// Copied from [telemetryChart].
class TelemetryChartFamily extends Family<AsyncValue<List<double>>> {
  ////////////////////////////////////////////////////////////
  /// TELEMETRY CHART
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [telemetryChart].
  const TelemetryChartFamily();

  ////////////////////////////////////////////////////////////
  /// TELEMETRY CHART
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [telemetryChart].
  TelemetryChartProvider call(
    String pondId,
    String deviceId,
    dynamic range,
    String metric,
  ) {
    return TelemetryChartProvider(pondId, deviceId, range, metric);
  }

  @override
  TelemetryChartProvider getProviderOverride(
    covariant TelemetryChartProvider provider,
  ) {
    return call(
      provider.pondId,
      provider.deviceId,
      provider.range,
      provider.metric,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'telemetryChartProvider';
}

////////////////////////////////////////////////////////////
/// TELEMETRY CHART
////////////////////////////////////////////////////////////
///
/// Copied from [telemetryChart].
class TelemetryChartProvider extends AutoDisposeFutureProvider<List<double>> {
  ////////////////////////////////////////////////////////////
  /// TELEMETRY CHART
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [telemetryChart].
  TelemetryChartProvider(
    String pondId,
    String deviceId,
    dynamic range,
    String metric,
  ) : this._internal(
        (ref) => telemetryChart(
          ref as TelemetryChartRef,
          pondId,
          deviceId,
          range,
          metric,
        ),
        from: telemetryChartProvider,
        name: r'telemetryChartProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$telemetryChartHash,
        dependencies: TelemetryChartFamily._dependencies,
        allTransitiveDependencies:
            TelemetryChartFamily._allTransitiveDependencies,
        pondId: pondId,
        deviceId: deviceId,
        range: range,
        metric: metric,
      );

  TelemetryChartProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pondId,
    required this.deviceId,
    required this.range,
    required this.metric,
  }) : super.internal();

  final String pondId;
  final String deviceId;
  final dynamic range;
  final String metric;

  @override
  Override overrideWith(
    FutureOr<List<double>> Function(TelemetryChartRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TelemetryChartProvider._internal(
        (ref) => create(ref as TelemetryChartRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pondId: pondId,
        deviceId: deviceId,
        range: range,
        metric: metric,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<double>> createElement() {
    return _TelemetryChartProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TelemetryChartProvider &&
        other.pondId == pondId &&
        other.deviceId == deviceId &&
        other.range == range &&
        other.metric == metric;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pondId.hashCode);
    hash = _SystemHash.combine(hash, deviceId.hashCode);
    hash = _SystemHash.combine(hash, range.hashCode);
    hash = _SystemHash.combine(hash, metric.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TelemetryChartRef on AutoDisposeFutureProviderRef<List<double>> {
  /// The parameter `pondId` of this provider.
  String get pondId;

  /// The parameter `deviceId` of this provider.
  String get deviceId;

  /// The parameter `range` of this provider.
  dynamic get range;

  /// The parameter `metric` of this provider.
  String get metric;
}

class _TelemetryChartProviderElement
    extends AutoDisposeFutureProviderElement<List<double>>
    with TelemetryChartRef {
  _TelemetryChartProviderElement(super.provider);

  @override
  String get pondId => (origin as TelemetryChartProvider).pondId;
  @override
  String get deviceId => (origin as TelemetryChartProvider).deviceId;
  @override
  dynamic get range => (origin as TelemetryChartProvider).range;
  @override
  String get metric => (origin as TelemetryChartProvider).metric;
}

String _$selectedRangeHash() =>
    r'570709827ee3d3b94b6d76ba2f8b2bbe2c956317'; ////////////////////////////////////////////////////////////
/// SELECTED RANGE
////////////////////////////////////////////////////////////
///
/// Copied from [SelectedRange].
@ProviderFor(SelectedRange)
final selectedRangeProvider =
    NotifierProvider<SelectedRange, ChartRange>.internal(
      SelectedRange.new,
      name: r'selectedRangeProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedRangeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedRange = Notifier<ChartRange>;
String _$liveSensorDataHash() => r'4ddcb6357f99e25566c17b457bb9804826fc94f8';

abstract class _$LiveSensorData
    extends BuildlessAsyncNotifier<SensorReadingModel> {
  late final String pondId;
  late final String deviceId;

  FutureOr<SensorReadingModel> build(String pondId, String deviceId);
}

////////////////////////////////////////////////////////////
/// LIVE SENSOR DATA
////////////////////////////////////////////////////////////
///
/// Copied from [LiveSensorData].
@ProviderFor(LiveSensorData)
const liveSensorDataProvider = LiveSensorDataFamily();

////////////////////////////////////////////////////////////
/// LIVE SENSOR DATA
////////////////////////////////////////////////////////////
///
/// Copied from [LiveSensorData].
class LiveSensorDataFamily extends Family<AsyncValue<SensorReadingModel>> {
  ////////////////////////////////////////////////////////////
  /// LIVE SENSOR DATA
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [LiveSensorData].
  const LiveSensorDataFamily();

  ////////////////////////////////////////////////////////////
  /// LIVE SENSOR DATA
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [LiveSensorData].
  LiveSensorDataProvider call(String pondId, String deviceId) {
    return LiveSensorDataProvider(pondId, deviceId);
  }

  @override
  LiveSensorDataProvider getProviderOverride(
    covariant LiveSensorDataProvider provider,
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
  String? get name => r'liveSensorDataProvider';
}

////////////////////////////////////////////////////////////
/// LIVE SENSOR DATA
////////////////////////////////////////////////////////////
///
/// Copied from [LiveSensorData].
class LiveSensorDataProvider
    extends AsyncNotifierProviderImpl<LiveSensorData, SensorReadingModel> {
  ////////////////////////////////////////////////////////////
  /// LIVE SENSOR DATA
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [LiveSensorData].
  LiveSensorDataProvider(String pondId, String deviceId)
    : this._internal(
        () => LiveSensorData()
          ..pondId = pondId
          ..deviceId = deviceId,
        from: liveSensorDataProvider,
        name: r'liveSensorDataProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$liveSensorDataHash,
        dependencies: LiveSensorDataFamily._dependencies,
        allTransitiveDependencies:
            LiveSensorDataFamily._allTransitiveDependencies,
        pondId: pondId,
        deviceId: deviceId,
      );

  LiveSensorDataProvider._internal(
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
  FutureOr<SensorReadingModel> runNotifierBuild(
    covariant LiveSensorData notifier,
  ) {
    return notifier.build(pondId, deviceId);
  }

  @override
  Override overrideWith(LiveSensorData Function() create) {
    return ProviderOverride(
      origin: this,
      override: LiveSensorDataProvider._internal(
        () => create()
          ..pondId = pondId
          ..deviceId = deviceId,
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
  AsyncNotifierProviderElement<LiveSensorData, SensorReadingModel>
  createElement() {
    return _LiveSensorDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LiveSensorDataProvider &&
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
mixin LiveSensorDataRef on AsyncNotifierProviderRef<SensorReadingModel> {
  /// The parameter `pondId` of this provider.
  String get pondId;

  /// The parameter `deviceId` of this provider.
  String get deviceId;
}

class _LiveSensorDataProviderElement
    extends AsyncNotifierProviderElement<LiveSensorData, SensorReadingModel>
    with LiveSensorDataRef {
  _LiveSensorDataProviderElement(super.provider);

  @override
  String get pondId => (origin as LiveSensorDataProvider).pondId;
  @override
  String get deviceId => (origin as LiveSensorDataProvider).deviceId;
}

String _$deviceAlertsHash() => r'aee4b8d816177232bd8f1b4a88ebd333245ff46c';

abstract class _$DeviceAlerts extends BuildlessAsyncNotifier<List<AlertModel>> {
  late final String pondId;
  late final String deviceId;

  FutureOr<List<AlertModel>> build(String pondId, String deviceId);
}

////////////////////////////////////////////////////////////
/// ALERTS
////////////////////////////////////////////////////////////
///
/// Copied from [DeviceAlerts].
@ProviderFor(DeviceAlerts)
const deviceAlertsProvider = DeviceAlertsFamily();

////////////////////////////////////////////////////////////
/// ALERTS
////////////////////////////////////////////////////////////
///
/// Copied from [DeviceAlerts].
class DeviceAlertsFamily extends Family<AsyncValue<List<AlertModel>>> {
  ////////////////////////////////////////////////////////////
  /// ALERTS
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [DeviceAlerts].
  const DeviceAlertsFamily();

  ////////////////////////////////////////////////////////////
  /// ALERTS
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [DeviceAlerts].
  DeviceAlertsProvider call(String pondId, String deviceId) {
    return DeviceAlertsProvider(pondId, deviceId);
  }

  @override
  DeviceAlertsProvider getProviderOverride(
    covariant DeviceAlertsProvider provider,
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
  String? get name => r'deviceAlertsProvider';
}

////////////////////////////////////////////////////////////
/// ALERTS
////////////////////////////////////////////////////////////
///
/// Copied from [DeviceAlerts].
class DeviceAlertsProvider
    extends AsyncNotifierProviderImpl<DeviceAlerts, List<AlertModel>> {
  ////////////////////////////////////////////////////////////
  /// ALERTS
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [DeviceAlerts].
  DeviceAlertsProvider(String pondId, String deviceId)
    : this._internal(
        () => DeviceAlerts()
          ..pondId = pondId
          ..deviceId = deviceId,
        from: deviceAlertsProvider,
        name: r'deviceAlertsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deviceAlertsHash,
        dependencies: DeviceAlertsFamily._dependencies,
        allTransitiveDependencies:
            DeviceAlertsFamily._allTransitiveDependencies,
        pondId: pondId,
        deviceId: deviceId,
      );

  DeviceAlertsProvider._internal(
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
  FutureOr<List<AlertModel>> runNotifierBuild(covariant DeviceAlerts notifier) {
    return notifier.build(pondId, deviceId);
  }

  @override
  Override overrideWith(DeviceAlerts Function() create) {
    return ProviderOverride(
      origin: this,
      override: DeviceAlertsProvider._internal(
        () => create()
          ..pondId = pondId
          ..deviceId = deviceId,
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
  AsyncNotifierProviderElement<DeviceAlerts, List<AlertModel>> createElement() {
    return _DeviceAlertsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeviceAlertsProvider &&
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
mixin DeviceAlertsRef on AsyncNotifierProviderRef<List<AlertModel>> {
  /// The parameter `pondId` of this provider.
  String get pondId;

  /// The parameter `deviceId` of this provider.
  String get deviceId;
}

class _DeviceAlertsProviderElement
    extends AsyncNotifierProviderElement<DeviceAlerts, List<AlertModel>>
    with DeviceAlertsRef {
  _DeviceAlertsProviderElement(super.provider);

  @override
  String get pondId => (origin as DeviceAlertsProvider).pondId;
  @override
  String get deviceId => (origin as DeviceAlertsProvider).deviceId;
}

String _$deviceAiInsightsHash() => r'9f32500faf7fa24ebef08039735b55014d13ac41';

abstract class _$DeviceAiInsights
    extends BuildlessAsyncNotifier<List<AiInsightModel>> {
  late final String pondId;
  late final String deviceId;

  FutureOr<List<AiInsightModel>> build(String pondId, String deviceId);
}

////////////////////////////////////////////////////////////
/// AI INSIGHTS
////////////////////////////////////////////////////////////
///
/// Copied from [DeviceAiInsights].
@ProviderFor(DeviceAiInsights)
const deviceAiInsightsProvider = DeviceAiInsightsFamily();

////////////////////////////////////////////////////////////
/// AI INSIGHTS
////////////////////////////////////////////////////////////
///
/// Copied from [DeviceAiInsights].
class DeviceAiInsightsFamily extends Family<AsyncValue<List<AiInsightModel>>> {
  ////////////////////////////////////////////////////////////
  /// AI INSIGHTS
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [DeviceAiInsights].
  const DeviceAiInsightsFamily();

  ////////////////////////////////////////////////////////////
  /// AI INSIGHTS
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [DeviceAiInsights].
  DeviceAiInsightsProvider call(String pondId, String deviceId) {
    return DeviceAiInsightsProvider(pondId, deviceId);
  }

  @override
  DeviceAiInsightsProvider getProviderOverride(
    covariant DeviceAiInsightsProvider provider,
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
  String? get name => r'deviceAiInsightsProvider';
}

////////////////////////////////////////////////////////////
/// AI INSIGHTS
////////////////////////////////////////////////////////////
///
/// Copied from [DeviceAiInsights].
class DeviceAiInsightsProvider
    extends AsyncNotifierProviderImpl<DeviceAiInsights, List<AiInsightModel>> {
  ////////////////////////////////////////////////////////////
  /// AI INSIGHTS
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [DeviceAiInsights].
  DeviceAiInsightsProvider(String pondId, String deviceId)
    : this._internal(
        () => DeviceAiInsights()
          ..pondId = pondId
          ..deviceId = deviceId,
        from: deviceAiInsightsProvider,
        name: r'deviceAiInsightsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deviceAiInsightsHash,
        dependencies: DeviceAiInsightsFamily._dependencies,
        allTransitiveDependencies:
            DeviceAiInsightsFamily._allTransitiveDependencies,
        pondId: pondId,
        deviceId: deviceId,
      );

  DeviceAiInsightsProvider._internal(
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
  FutureOr<List<AiInsightModel>> runNotifierBuild(
    covariant DeviceAiInsights notifier,
  ) {
    return notifier.build(pondId, deviceId);
  }

  @override
  Override overrideWith(DeviceAiInsights Function() create) {
    return ProviderOverride(
      origin: this,
      override: DeviceAiInsightsProvider._internal(
        () => create()
          ..pondId = pondId
          ..deviceId = deviceId,
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
  AsyncNotifierProviderElement<DeviceAiInsights, List<AiInsightModel>>
  createElement() {
    return _DeviceAiInsightsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeviceAiInsightsProvider &&
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
mixin DeviceAiInsightsRef on AsyncNotifierProviderRef<List<AiInsightModel>> {
  /// The parameter `pondId` of this provider.
  String get pondId;

  /// The parameter `deviceId` of this provider.
  String get deviceId;
}

class _DeviceAiInsightsProviderElement
    extends AsyncNotifierProviderElement<DeviceAiInsights, List<AiInsightModel>>
    with DeviceAiInsightsRef {
  _DeviceAiInsightsProviderElement(super.provider);

  @override
  String get pondId => (origin as DeviceAiInsightsProvider).pondId;
  @override
  String get deviceId => (origin as DeviceAiInsightsProvider).deviceId;
}

String _$deviceStatusHash() => r'f33a375aaee6a4982d504aa02760c0510d3fa4ec';

abstract class _$DeviceStatus
    extends BuildlessAsyncNotifier<DeviceStatusModel> {
  late final String deviceId;

  FutureOr<DeviceStatusModel> build(String deviceId);
}

////////////////////////////////////////////////////////////
/// DEVICE STATUS
////////////////////////////////////////////////////////////
///
/// Copied from [DeviceStatus].
@ProviderFor(DeviceStatus)
const deviceStatusProvider = DeviceStatusFamily();

////////////////////////////////////////////////////////////
/// DEVICE STATUS
////////////////////////////////////////////////////////////
///
/// Copied from [DeviceStatus].
class DeviceStatusFamily extends Family<AsyncValue<DeviceStatusModel>> {
  ////////////////////////////////////////////////////////////
  /// DEVICE STATUS
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [DeviceStatus].
  const DeviceStatusFamily();

  ////////////////////////////////////////////////////////////
  /// DEVICE STATUS
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [DeviceStatus].
  DeviceStatusProvider call(String deviceId) {
    return DeviceStatusProvider(deviceId);
  }

  @override
  DeviceStatusProvider getProviderOverride(
    covariant DeviceStatusProvider provider,
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
  String? get name => r'deviceStatusProvider';
}

////////////////////////////////////////////////////////////
/// DEVICE STATUS
////////////////////////////////////////////////////////////
///
/// Copied from [DeviceStatus].
class DeviceStatusProvider
    extends AsyncNotifierProviderImpl<DeviceStatus, DeviceStatusModel> {
  ////////////////////////////////////////////////////////////
  /// DEVICE STATUS
  ////////////////////////////////////////////////////////////
  ///
  /// Copied from [DeviceStatus].
  DeviceStatusProvider(String deviceId)
    : this._internal(
        () => DeviceStatus()..deviceId = deviceId,
        from: deviceStatusProvider,
        name: r'deviceStatusProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deviceStatusHash,
        dependencies: DeviceStatusFamily._dependencies,
        allTransitiveDependencies:
            DeviceStatusFamily._allTransitiveDependencies,
        deviceId: deviceId,
      );

  DeviceStatusProvider._internal(
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
  FutureOr<DeviceStatusModel> runNotifierBuild(
    covariant DeviceStatus notifier,
  ) {
    return notifier.build(deviceId);
  }

  @override
  Override overrideWith(DeviceStatus Function() create) {
    return ProviderOverride(
      origin: this,
      override: DeviceStatusProvider._internal(
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
  AsyncNotifierProviderElement<DeviceStatus, DeviceStatusModel>
  createElement() {
    return _DeviceStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeviceStatusProvider && other.deviceId == deviceId;
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
mixin DeviceStatusRef on AsyncNotifierProviderRef<DeviceStatusModel> {
  /// The parameter `deviceId` of this provider.
  String get deviceId;
}

class _DeviceStatusProviderElement
    extends AsyncNotifierProviderElement<DeviceStatus, DeviceStatusModel>
    with DeviceStatusRef {
  _DeviceStatusProviderElement(super.provider);

  @override
  String get deviceId => (origin as DeviceStatusProvider).deviceId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
