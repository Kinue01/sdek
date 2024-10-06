import 'package:clientapp/domain/model/OAuth2GoogleCodeResponse.dart';
import 'package:clientapp/domain/model/User.dart';

abstract class AuthorisationOauthRepository {
  Future<String> googleGetUrl();
  Future<bool> revokeTokenBySecret(String secret);
  Future<String> sendAuthCode(OAuth2GoogleCodeResponse response);
  Future<User> getUserByLoginPass(User user);
}