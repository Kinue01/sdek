import 'package:dio/dio.dart';
import '../../domain/model/OAuth2GoogleCodeResponse.dart';

abstract class AuthorisationApi {
  Future<String> googleGetUrl();
  Future<bool> revokeTokenBySecret(String secret);
  Future<String> sendAuthCode(OAuth2GoogleCodeResponse response);
}

class AuthorisationApiImpl implements AuthorisationApi {
  final Dio client;

  AuthorisationApiImpl({
    required this.client
  });

  String get url => "http://localhost/userservice";

  @override
  Future<String> googleGetUrl() async {
    Response<String> response = await client.get("$url/api/google_get_url");
    switch (response.statusCode) {
      case 200:
        return response.data!;
      default:
        return "";
    }
  }

  @override
  Future<String> sendAuthCode(OAuth2GoogleCodeResponse response) async {
    Response<Map<String, dynamic>> resp = await client.post("$url/api/google_get_token", data: response.toRawJson());
    switch (resp.statusCode) {
      case 200:
        return resp.data!['access'].toString();
      default:
        return "";
    }
  }

  @override
  Future<bool> revokeTokenBySecret(String secret) async {
    Response response = await client.post("$url/api/google_revoke_token", data: secret);
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }
}