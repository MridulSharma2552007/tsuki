abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  RegisterRequested({required this.email, required this.password});
}

class VerifyRequested extends AuthEvent {
  final String email;
  final String code;
  VerifyRequested({required this.email, required this.code});
}

class LogoutRequested extends AuthEvent {}
