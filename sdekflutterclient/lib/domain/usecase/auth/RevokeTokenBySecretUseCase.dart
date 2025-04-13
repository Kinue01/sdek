import 'package:clientapp/domain/repository/authorisation_repository.dart';

class RevokeTokenBySecretUseCase {
  AuthorisationOauthRepository repository;

  RevokeTokenBySecretUseCase({
    required this.repository
  });

  Future<bool> exec(String secret) async {
    return await repository.revokeTokenBySecret(secret);
  }
}