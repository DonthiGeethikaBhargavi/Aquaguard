import '../repositories/auth_repository.dart';

class SignOut {
  final AuthRepository repo;

  SignOut(this.repo);

  Future call() {
    return repo.signOut();
  }
}
