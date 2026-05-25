import 'package:supabase_flutter/supabase_flutter.dart';

class PondRemoteDataSource {
  final supabase = Supabase.instance.client;

  ////////////////////////////////////////////////////////////
  /// FETCH PONDS + DEVICES + READINGS
  ////////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>> fetchPonds() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final response = await supabase
        .from('ponds')
        .select('''
  pond_id,
  pond_name,
  latitude,
  longitude,
  devices (
    device_id,
    latest_readings (
      temperature,
      ph,
      dissolved_oxygen,
      water_level,
      last_update
    )
  )
''')
        .eq('user_id', user.id);

    return List<Map<String, dynamic>>.from(response);
  }

  ////////////////////////////////////////////////////////////
  /// ADD POND
  ////////////////////////////////////////////////////////////
  Future<void> addPond({
    required String name,
    required String userId,
    required double lat,
    required double lng,
  }) async {
    await supabase.from('ponds').insert({
      'pond_name': name,
      'user_id': userId,
      'latitude': lat,
      'longitude': lng,
    });
  }

  ////////////////////////////////////////////////////////////
  /// DELETE SINGLE
  ////////////////////////////////////////////////////////////
  Future<void> deletePond(String pondId) async {
    await supabase.from('ponds').delete().eq('pond_id', pondId);
  }

  ////////////////////////////////////////////////////////////
  /// DELETE ALL
  ////////////////////////////////////////////////////////////
  Future<void> deleteAll(String userId) async {
    await supabase.from('ponds').delete().eq('user_id', userId);
  }
}
