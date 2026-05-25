// features/auth/data/repositories/auth_repository_impl.dart

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Stream<AuthState> authStateChanges() {
    return remote.authStateChanges();
  }

  @override
  Future<AuthResponse> login(String email, String password) {
    return remote.signIn(email: email, password: password);
  }

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  }) {
    return remote.signUp(email: email, password: password, name: name);
  }

  @override
  Future<void> signOut() {
    return remote.signOut();
  }
}
