import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

part 'pond_devices_provider.g.dart';

////////////////////////////////////////////////////////////
/// MODEL
////////////////////////////////////////////////////////////

class PondDeviceModel {
  final String deviceId;

  final String pondId;

  final String deviceName;

  final bool isOnline;

  final DateTime? lastSeen;

  PondDeviceModel({
    required this.deviceId,
    required this.pondId,
    required this.deviceName,
    required this.isOnline,
    required this.lastSeen,
  });

  factory PondDeviceModel.fromJson(Map<String, dynamic> json) {
    return PondDeviceModel(
      deviceId: json['device_id'] ?? '',

      pondId: json['pond_id'] ?? '',

      deviceName: json['device_name'] ?? 'AquaGuard Device',

      isOnline: json['is_online'] ?? false,

      lastSeen: json['last_seen'] != null
          ? DateTime.tryParse(json['last_seen'])
          : null,
    );
  }
}

////////////////////////////////////////////////////////////
/// PROVIDER
////////////////////////////////////////////////////////////

@Riverpod(keepAlive: true)
class PondDevices extends _$PondDevices {
  StreamSubscription? _subscription;

  ////////////////////////////////////////////////////////////
  /// BUILD
  ////////////////////////////////////////////////////////////

  @override
  Future<List<PondDeviceModel>> build(String pondId) async {
    final supabase = Supabase.instance.client;

    //////////////////////////////////////////////////////////
    /// INITIAL LOAD
    //////////////////////////////////////////////////////////

    final response = await supabase
        .from('devices')
        .select()
        .eq('pond_id', pondId)
        .order('created_at', ascending: false);

    final devices = response
        .map<PondDeviceModel>((e) => PondDeviceModel.fromJson(e))
        .toList();

    //////////////////////////////////////////////////////////
    /// REALTIME
    //////////////////////////////////////////////////////////

    _subscription?.cancel();

    _subscription = supabase
        .from('devices')
        .stream(primaryKey: ['device_id'])
        .eq('pond_id', pondId)
        .listen((rows) {
          final updated = rows
              .map<PondDeviceModel>((e) => PondDeviceModel.fromJson(e))
              .toList();

          state = AsyncData(updated);
        });

    //////////////////////////////////////////////////////////
    /// CLEANUP
    //////////////////////////////////////////////////////////

    ref.onDispose(() async {
      await _subscription?.cancel();
    });

    return devices;
  }
}
