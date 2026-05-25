import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasource/device_remote_datasource.dart';

////////////////////////////////////////////////////////////
/// REMOTE PROVIDER
////////////////////////////////////////////////////////////

final deviceRemoteProvider = Provider<DeviceRemoteDatasource>((ref) {
  return DeviceRemoteDatasource(Supabase.instance.client);
});

////////////////////////////////////////////////////////////
/// DEVICE NOTIFIER
////////////////////////////////////////////////////////////

class DeviceListNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final Ref ref;

  final String pondId;

  DeviceListNotifier(this.ref, this.pondId) : super(const AsyncLoading()) {
    load();
  }

  ////////////////////////////////////////////////////////////
  /// LOAD
  ////////////////////////////////////////////////////////////

  Future<void> load() async {
    try {
      final devices = await ref.read(deviceRemoteProvider).getDevices(pondId);

      state = AsyncData(devices);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  ////////////////////////////////////////////////////////////
  /// REFRESH
  ////////////////////////////////////////////////////////////

  Future<void> refresh() async {
    try {
      final devices = await ref.read(deviceRemoteProvider).getDevices(pondId);

      state = AsyncData(devices);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  ////////////////////////////////////////////////////////////
  /// ADD DEVICE
  ////////////////////////////////////////////////////////////

  Future<void> add({required String deviceId, required String userId}) async {
    final current = state.value ?? [];

    //////////////////////////////////////////////////////////
    /// OPTIMISTIC INSERT
    //////////////////////////////////////////////////////////

    final optimisticDevice = {
      'device_id': deviceId,

      'pond_id': pondId,

      'user_id': userId,

      'mac_address': 'Connecting...',

      'is_online': true,

      'created_at': DateTime.now().toIso8601String(),
    };

    state = AsyncData([optimisticDevice, ...current]);

    try {
      ////////////////////////////////////////////////////////
      /// BACKEND INSERT
      ////////////////////////////////////////////////////////

      await ref
          .read(deviceRemoteProvider)
          .addDevice(deviceId: deviceId, pondId: pondId, userId: userId);

      ////////////////////////////////////////////////////////
      /// SILENT REFRESH
      ////////////////////////////////////////////////////////

      await refresh();
    } catch (e) {
      ////////////////////////////////////////////////////////
      /// ROLLBACK
      ////////////////////////////////////////////////////////

      state = AsyncData(current);

      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////
  /// DELETE DEVICE
  ////////////////////////////////////////////////////////////

  Future<void> delete(String deviceId) async {
    final current = state.value ?? [];

    //////////////////////////////////////////////////////////
    /// OPTIMISTIC REMOVE
    //////////////////////////////////////////////////////////

    state = AsyncData(
      current.where((d) => d['device_id'] != deviceId).toList(),
    );

    try {
      ////////////////////////////////////////////////////////
      /// DELETE FROM SUPABASE
      ////////////////////////////////////////////////////////

      await ref.read(deviceRemoteProvider).deleteDevice(deviceId);
    } catch (e) {
      ////////////////////////////////////////////////////////
      /// ROLLBACK
      ////////////////////////////////////////////////////////

      state = AsyncData(current);

      rethrow;
    }
  }
}

////////////////////////////////////////////////////////////
/// PROVIDER
////////////////////////////////////////////////////////////

final deviceListProvider =
    StateNotifierProvider.family<
      DeviceListNotifier,
      AsyncValue<List<Map<String, dynamic>>>,
      String
    >((ref, pondId) {
      return DeviceListNotifier(ref, pondId);
    });
