import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository repo;

  Login(this.repo);

  Future call(String email, String password) {
    return repo.login(email, password);
  }
}
