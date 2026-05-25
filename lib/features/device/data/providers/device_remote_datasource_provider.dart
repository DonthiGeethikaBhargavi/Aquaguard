import 'package:aquaguard/features/device/data/datasource/device_remote_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'device_remote_datasource_provider.g.dart';

@riverpod
DeviceRemoteDatasource deviceRemoteDatasource(DeviceRemoteDatasourceRef ref) {
  final supabase = Supabase.instance.client;
  return DeviceRemoteDatasource(supabase);
}
