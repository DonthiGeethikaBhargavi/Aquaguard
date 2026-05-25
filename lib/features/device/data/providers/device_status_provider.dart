import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:aquaguard/features/device/data/models/device_status_model.dart';

import '../../../../core/services/logger_service.dart';

import 'device_remote_datasource_provider.dart';

part 'device_status_provider.g.dart';

////////////////////////////////////////////////////////////
/// MEMORY CACHE
////////////////////////////////////////////////////////////

final Map<String, DeviceStatusModel> _deviceStatusCache = {};

final Map<String, DateTime> _cacheTimestamps = {};

////////////////////////////////////////////////////////////
/// PROVIDER
////////////////////////////////////////////////////////////

@riverpod
class DeviceStatusProvider extends _$DeviceStatusProvider {
  final LoggerService _logger = LoggerService();

  StreamSubscription? _subscription;

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Stream<DeviceStatusModel> build(String deviceId) async* {
    final datasource = ref.watch(deviceRemoteDatasourceProvider);

    //////////////////////////////////////////////////////////
    /// CACHE HYDRATION
    //////////////////////////////////////////////////////////

    final cached = _deviceStatusCache[deviceId];

    if (cached != null) {
      _logger.provider(
        'DeviceStatusProvider',

        action: 'cache_hydrated',

        data: {'deviceId': deviceId},
      );

      yield cached;
    }

    //////////////////////////////////////////////////////////
    /// INITIAL DATABASE FETCH
    //////////////////////////////////////////////////////////

    try {
      final initial = await datasource.getDeviceStatus(deviceId);

      ////////////////////////////////////////////////////////
      /// INITIAL FOUND
      ////////////////////////////////////////////////////////

      if (initial != null) {
        //////////////////////////////////////////////////////
        /// UPDATE CACHE
        //////////////////////////////////////////////////////

        _deviceStatusCache[deviceId] = initial;

        _cacheTimestamps[deviceId] = DateTime.now();

        //////////////////////////////////////////////////////
        /// LOG
        //////////////////////////////////////////////////////

        _logger.provider(
          'DeviceStatusProvider',

          action: 'initial_data_loaded',

          data: {'deviceId': deviceId},
        );

        //////////////////////////////////////////////////////
        /// EMIT INITIAL
        //////////////////////////////////////////////////////

        yield initial;
      } else {
        //////////////////////////////////////////////////////
        /// FALLBACK STATUS
        //////////////////////////////////////////////////////

        final fallback = DeviceStatusModel(
          deviceId: deviceId,

          isOnline: false,

          lastSeen: DateTime.now(),

          batteryLevel: 0,
        );

        //////////////////////////////////////////////////////
        /// CACHE
        //////////////////////////////////////////////////////

        _deviceStatusCache[deviceId] = fallback;

        _cacheTimestamps[deviceId] = DateTime.now();

        //////////////////////////////////////////////////////
        /// LOG
        //////////////////////////////////////////////////////

        _logger.warning(
          'No initial device status found',

          tag: 'DEVICE_STATUS',

          data: {'deviceId': deviceId},
        );

        //////////////////////////////////////////////////////
        /// EMIT FALLBACK
        //////////////////////////////////////////////////////

        yield fallback;
      }
    } catch (e, stack) {
      ////////////////////////////////////////////////////////
      /// ERROR FALLBACK
      ////////////////////////////////////////////////////////

      final fallback = DeviceStatusModel(
        deviceId: deviceId,

        isOnline: false,

        lastSeen: DateTime.now(),

        batteryLevel: 0,
      );

      ////////////////////////////////////////////////////////
      /// LOG
      ////////////////////////////////////////////////////////

      _logger.error(
        'Initial device status fetch failed',

        tag: 'DEVICE_STATUS',

        error: e,

        stackTrace: stack,
      );

      ////////////////////////////////////////////////////////
      /// EMIT SAFE FALLBACK
      ////////////////////////////////////////////////////////

      yield fallback;
    }

    //////////////////////////////////////////////////////////
    /// REALTIME STREAM
    //////////////////////////////////////////////////////////

    final controller = StreamController<DeviceStatusModel>();

    _subscription = datasource
        .subscribeToDeviceStatus(deviceId)
        .listen(
          (event) {
            //////////////////////////////////////////////////
            /// UPDATE CACHE
            //////////////////////////////////////////////////

            _deviceStatusCache[deviceId] = event;

            _cacheTimestamps[deviceId] = DateTime.now();

            //////////////////////////////////////////////////
            /// LOG
            //////////////////////////////////////////////////

            _logger.realtime(
              'Device status updated',

              data: {'deviceId': deviceId, 'online': event.isOnline},
            );

            //////////////////////////////////////////////////
            /// EMIT
            //////////////////////////////////////////////////

            controller.add(event);
          },

          ////////////////////////////////////////////////////
          /// ERROR
          ////////////////////////////////////////////////////
          onError: (error, stack) {
            _logger.error(
              'Device status stream failed',

              tag: 'DEVICE_STATUS',

              error: error,

              stackTrace: stack,
            );

            //////////////////////////////////////////////////
            /// FALLBACK CACHE
            //////////////////////////////////////////////////

            final cached = _deviceStatusCache[deviceId];

            if (cached != null) {
              controller.add(cached);
            }
          },
        );

    //////////////////////////////////////////////////////////
    /// CLEANUP
    //////////////////////////////////////////////////////////

    ref.onDispose(() async {
      await _subscription?.cancel();

      await controller.close();
    });

    //////////////////////////////////////////////////////////
    /// REALTIME EVENTS
    //////////////////////////////////////////////////////////

    yield* controller.stream;
  }

  ////////////////////////////////////////////////////////////
  /// CACHE HELPERS
  ////////////////////////////////////////////////////////////

  DeviceStatusModel? getCached(String deviceId) {
    return _deviceStatusCache[deviceId];
  }

  DateTime? getCacheTime(String deviceId) {
    return _cacheTimestamps[deviceId];
  }

  bool isCacheFresh(String deviceId) {
    final time = _cacheTimestamps[deviceId];

    if (time == null) {
      return false;
    }

    final age = DateTime.now().difference(time);

    return age.inMinutes < 5;
  }

  void clearCache(String deviceId) {
    _deviceStatusCache.remove(deviceId);

    _cacheTimestamps.remove(deviceId);

    _logger.provider(
      'DeviceStatusProvider',

      action: 'cache_cleared',

      data: {'deviceId': deviceId},
    );
  }
}
