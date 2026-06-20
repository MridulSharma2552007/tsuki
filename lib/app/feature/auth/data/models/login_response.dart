class LoginResponse {
  final String accessToken;
  final String idToken;
  final String refreshToken;

  LoginResponse({
    required this.accessToken,
    required this.idToken,
    required this.refreshToken,
  });

  factory LoginResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginResponse(
      accessToken: json['accessToken'],
      idToken: json['idToken'],
      refreshToken: json['refreshToken'],
    );
  }
}