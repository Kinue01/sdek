import 'package:clientapp/data/repository/authorisation_data_repository.dart';
import 'package:clientapp/domain/model/OAuth2GoogleCodeResponse.dart';
import 'package:clientapp/domain/repository/authorisation_repository.dart';

class AuthorisationOauthRepositoryImpl implements AuthorisationOauthRepository {
  AuthorisationOauthDataRepository repository;

  AuthorisationOauthRepositoryImpl({
    required this.repository
  });

  @override
  Future<String> googleGetUrl() async {
    return await repository.googleGetUrl();
  }

  @override
  Future<String> sendAuthCode(OAuth2GoogleCodeResponse response) async {
    return await repository.sendAuthCode(response);
  }

  @override
  Future<bool> revokeTokenBySecret(String secret) async {
    return await repository.revokeTokenBySecret(secret);
  }
}