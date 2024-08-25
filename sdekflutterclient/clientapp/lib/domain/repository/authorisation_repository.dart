import 'package:clientapp/domain/model/OAuth2GoogleCodeResponse.dart';

abstract class AuthorisationOauthRepository {
  Future<String> google_getUrl();
  Future<String> getTokenByUserId(String uuid);
  Future<void> sendAuthCode(OAuth2GoogleCodeResponse response);
}