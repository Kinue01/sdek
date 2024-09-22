import 'package:clientapp/domain/model/OAuth2GoogleCodeResponse.dart';

abstract class AuthorisationOauthDataRepository {
  Future<String> googleGetUrl();
  Future<String> getTokenByUserId(String uuid);
  Future<bool> sendAuthCode(OAuth2GoogleCodeResponse response);
}