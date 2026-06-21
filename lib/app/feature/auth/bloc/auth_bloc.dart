import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await repository.login(event.email, event.password);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await repository.register(event.email, event.password);
        emit(VerificationRequired(event.email));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<VerifyRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await repository.verify(event.email, event.code);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
