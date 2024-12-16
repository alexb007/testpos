part of 'home_bloc.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  final Widget page;
  const HomeLoaded(this.page);
}
