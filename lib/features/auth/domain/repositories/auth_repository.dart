// features/auth/domain/repositories/auth_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Stream<AuthState> authStateChanges();

  Future<AuthResponse> login(String email, String password);

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<void> signOut();
}
