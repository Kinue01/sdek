import 'dart:convert';

class OAuth2GoogleCodeResponse {
  final String code;
  final String state;

  OAuth2GoogleCodeResponse({
    required this.code,
    required this.state
  });

  factory OAuth2GoogleCodeResponse.fromRawJson(String str) =>
      OAuth2GoogleCodeResponse.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory OAuth2GoogleCodeResponse.fromMap(Map<String, dynamic> json) => OAuth2GoogleCodeResponse(
    code: json['code'],
    state: json['state'],
  );

  Map<String, dynamic> toMap() => {
    'code': code,
    'state': state,
  };
}