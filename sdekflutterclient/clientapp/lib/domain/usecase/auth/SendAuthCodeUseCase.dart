import 'package:clientapp/domain/model/OAuth2GoogleCodeResponse.dart';
import 'package:clientapp/domain/repository/authorisation_repository.dart';

class SendAuthCodeUseCase {
  AuthorisationOauthRepository repository;

  SendAuthCodeUseCase({
    required this.repository
  });

  Future<String> exec(OAuth2GoogleCodeResponse resp) async {
    return await repository.sendAuthCode(resp);
  }
}