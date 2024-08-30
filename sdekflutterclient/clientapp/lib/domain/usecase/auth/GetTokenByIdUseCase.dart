import 'package:clientapp/domain/repository/authorisation_repository.dart';

class GetTokenByIdUseCase {
  AuthorisationOauthRepository repository;

  GetTokenByIdUseCase({
    required this.repository
  });

  Future<String> exec(String uuid) async {
    return await repository.getTokenByUserId(uuid);
  }
}