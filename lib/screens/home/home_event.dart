part of 'home_bloc.dart';

sealed class HomeEvent {
  const HomeEvent();
}

final class LoadHome extends HomeEvent {
  const LoadHome();
}

final class ChangePage extends HomeEvent {
  final Widget page;
  const ChangePage(this.page);
}
