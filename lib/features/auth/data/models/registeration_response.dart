class RegisterResponse {
  final String message;
  final String userSub;

  RegisterResponse({required this.message, required this.userSub});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(message: json['message'], userSub: json['userSub']);
  }
}
