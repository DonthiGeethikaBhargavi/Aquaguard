import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repo;

  SignUp(this.repo);

  Future call({
    required String email,
    required String password,
    required String name,
  }) {
    return repo.signUp(email: email, password: password, name: name);
  }
}
