import 'package:clientapp/domain/repository/authorisation_repository.dart';

class GetGoogleUrlUseCase {
  AuthorisationOauthRepository repository;

  GetGoogleUrlUseCase({
    required this.repository
  });

  Future<String> exec() async {
    return await repository.googleGetUrl();
  }
}