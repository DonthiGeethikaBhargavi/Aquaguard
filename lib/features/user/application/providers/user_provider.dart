import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

////////////////////////////////////////////////////////////
/// USER PROFILE FROM DB
////////////////////////////////////////////////////////////
/// Table assumed: users_profile
/// Columns expected:
/// - id (uuid, same as auth user id)
/// - name (text)
/// - aquatic_type (text or nullable)
final userDataProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final client = Supabase.instance.client;
  final user = client.auth.currentUser;

  ////////////////////////////////////////////////////////////
  /// NOT LOGGED IN → NO DATA
  ////////////////////////////////////////////////////////////
  if (user == null) return null;

  ////////////////////////////////////////////////////////////
  /// FETCH PROFILE
  ////////////////////////////////////////////////////////////
  try {
    final data = await client
        .from('users_profile')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return data; // can be null → onboarding case
  } catch (e) {
    ////////////////////////////////////////////////////////////
    /// FAIL SAFE
    ////////////////////////////////////////////////////////////
    return null;
  }
});
