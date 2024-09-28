import 'package:clientapp/data/repository/authorisation_data_repository.dart';
import 'package:clientapp/domain/model/OAuth2GoogleCodeResponse.dart';
import 'package:clientapp/remote/api/authorisation_api.dart';

class AuthorisationDataRepositoryImpl implements AuthorisationOauthDataRepository {
  AuthorisationApi authorisationApi;

  AuthorisationDataRepositoryImpl({
    required this.authorisationApi
  });

  @override
  Future<String> googleGetUrl() async {
    return await authorisationApi.googleGetUrl();
  }

  @override
  Future<bool> revokeTokenBySecret(String secret) async {
    return await authorisationApi.revokeTokenBySecret(secret);
  }

  @override
  Future<String> sendAuthCode(OAuth2GoogleCodeResponse response) async {
    return await authorisationApi.sendAuthCode(response);
  }
}