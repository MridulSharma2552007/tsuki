import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await repository.register(event.email, event.password);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
