import 'package:envied/envied.dart';

part 'Env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'PROD_API_URL', obfuscate: true)
  static String prod_api_url = _Env.prod_api_url;
  @EnviedField(varName: 'DEV_API_URL', obfuscate: true)
  static String dev_api_url = _Env.dev_api_url;
  @EnviedField(varName: 'PROD_WS', obfuscate: true)
  static String prod_ws = _Env.prod_ws;
  @EnviedField(varName: 'DEV_WS', obfuscate: true)
  static String dev_ws = _Env.dev_ws;
}