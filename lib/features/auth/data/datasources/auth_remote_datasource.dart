import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  final _client = Supabase.instance.client;

  /// 🔄 Auth state stream
  Stream<AuthState> authStateChanges() {
    return _client.auth.onAuthStateChange;
  }

  /// 🔐 SIGN UP
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'name': name, // 🔥 used by trigger function
      },
    );

    ////////////////////////////////////////////////////////////
    /// ❌ DO NOT INSERT PROFILE HERE
    /// Trigger (auth.users) will handle it
    ////////////////////////////////////////////////////////////

    return response;
  }

  /// 🔐 SIGN IN (recommended to add)
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// 🚪 SIGN OUT
  Future<void> signOut() {
    return _client.auth.signOut();
  }
}
