import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsuki/features/home/bloc/home_event.dart';
import 'package:tsuki/features/home/bloc/home_state.dart';
import 'package:tsuki/features/home/data/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;
  HomeBloc(this.repository) : super(HomeInitial()) {
    on<GetFeaturedFeed>((event, emit) async {
      emit(HomeLoading());
      try {
        final response = await repository.getFeaturedFeed();

        emit(HomeDataLoaded(response));
      } catch (e) {
        print(e);
      }
    });
  }
}
