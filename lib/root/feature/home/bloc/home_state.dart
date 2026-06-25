import 'package:tsuki/root/feature/home/data/model/featured_response.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class LoadFeaturedFeed extends HomeState {}

class HomeDataLoaded extends HomeState {
  final FeaturedResponse featured;

  HomeDataLoaded(this.featured);
}
