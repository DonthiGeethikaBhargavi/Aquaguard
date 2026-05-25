import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../datasource/alert_analytics_remote_datasource.dart';

final alertAnalyticsDatasourceProvider =
    Provider<AlertAnalyticsRemoteDatasource>((ref) {
      final supabase = Supabase.instance.client;

      return AlertAnalyticsRemoteDatasource(supabase);
    });
