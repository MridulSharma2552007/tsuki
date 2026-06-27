abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {}

class VerificationRequired extends AuthState {
  final String email;
  VerificationRequired(this.email);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
