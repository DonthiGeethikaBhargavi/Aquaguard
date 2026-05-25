import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../datasource/alerts_remote_datasource.dart';

final alertsRemoteDatasourceProvider = Provider<AlertsRemoteDatasource>((ref) {
  final supabase = Supabase.instance.client;

  return AlertsRemoteDatasource(supabase);
});
