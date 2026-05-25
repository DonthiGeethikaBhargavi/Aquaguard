import '../../../../core/network/supabase_client.dart';

class UserRemoteDataSource {
  Future<Map<String, dynamic>?> getUser(String userId) async {
    return await supabase
        .from('users_profile')
        .select()
        .eq('id', userId)
        .maybeSingle();
  }

  // 🔥 create profile on first login
  Future<void> createUser({required String id, required String email}) async {
    await supabase.from('users_profile').insert({
      'id': id,
      'name': 'User',
      'email': email,
    });
  }

  // 🐟 onboarding complete
  Future<void> completeOnboarding({
    required String userId,
    required String type,
  }) async {
    await supabase
        .from('users_profile')
        .update({
          'aquatic_type': type,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId);
  }
}
