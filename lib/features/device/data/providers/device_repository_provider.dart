import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../datasource/device_remote_datasource.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/repositories/device_repository_interface.dart';

final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  final supabase = Supabase.instance.client;
  final datasource = DeviceRemoteDatasource(supabase);
  return DeviceRepositoryImpl(datasource);
});
