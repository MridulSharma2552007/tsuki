import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      print('[BLOC] LoginRequested');
      print('[BLOC] Email: ${event.email}');

      emit(AuthLoading());

      try {
        await repository.login(event.email, event.password);

        print('[BLOC] Login Success');

        emit(Authenticated());
      } catch (e) {
        print('[BLOC] Login Failed');
        print('[BLOC] Error: $e');

        emit(AuthError(e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      print('[BLOC] RegisterRequested');
      print('[BLOC] Email: ${event.email}');

      emit(AuthLoading());

      try {
        await repository.register(event.email, event.password);

        print('[BLOC] Registration Success');
        print('[BLOC] Moving to verification');

        emit(VerificationRequired(event.email));
      } catch (e) {
        print('[BLOC] Registration Failed');
        print('[BLOC] Error: $e');

        emit(AuthError(e.toString()));
      }
    });

    on<VerifyRequested>((event, emit) async {
      print('[BLOC] VerifyRequested');
      print('[BLOC] Email: ${event.email}');
      print('[BLOC] Code: ${event.code}');

      emit(AuthLoading());

      try {
        await repository.verify(event.email, event.code);

        print('[BLOC] Verification Success');

        emit(Authenticated());
      } catch (e) {
        print('[BLOC] Verification Failed');
        print('[BLOC] Error: $e');

        emit(AuthError(e.toString()));
      }
    });
  }
}
