// features/auth/application/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/sign_out.dart';

final authRemoteProvider = Provider((ref) {
  return AuthRemoteDataSource();
});

final authRepositoryProvider = Provider((ref) {
  return AuthRepositoryImpl(ref.read(authRemoteProvider));
});

final loginProvider = Provider((ref) {
  return Login(ref.read(authRepositoryProvider));
});

final signUpProvider = Provider((ref) {
  return SignUp(ref.read(authRepositoryProvider));
});

final signOutProvider = Provider((ref) {
  return SignOut(ref.read(authRepositoryProvider));
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.read(authRepositoryProvider).authStateChanges();
});
