import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// key format → "$pondId|$range"
final statsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>(
  (ref, key) async {
    final client = Supabase.instance.client;

    // ================= PARSE INPUT =================

    final parts = key.split('|');

    if (parts.isEmpty || parts[0].isEmpty) {
      throw Exception("Invalid stats key");
    }

    final pondId = parts[0];
    final range = parts.length > 1 ? parts[1] : 'hour';

    // ================= TABLE MAPPING =================

    late String table;
    late String timeColumn;

    switch (range) {
      case 'hour':
        table = 'hourly_stats';
        timeColumn = 'hour';
        break;

      case 'day':
        table = 'daily_stats';
        timeColumn = 'day';
        break;

      case 'week':
        table = 'weekly_stats';
        timeColumn = 'week';
        break;

      case 'month':
        table = 'monthly_stats';
        timeColumn = 'month';
        break;

      case 'year':
      default:
        table = 'yearly_stats';
        timeColumn = 'year';
    }

    // ================= FETCH DATA =================

    try {
      final res = await client
          .from(table)
          .select()
          .eq('pond_id', pondId) // 🔥 MUST MATCH DB
          .order(timeColumn, ascending: true)
          .limit(50); // ✅ prevent overload

      // ================= SAFE CAST =================

      final data = List<Map<String, dynamic>>.from(res);

      // ================= DEBUG (REMOVE LATER) =================
      // ignore: avoid_print
      print("📊 Stats fetched (${data.length}) for $range");

      return data;
    } catch (e) {
      throw Exception("Stats fetch failed: $e");
    }
  },
);
