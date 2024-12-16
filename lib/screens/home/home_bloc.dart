import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testorders/screens/tables/tables.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeLoading()) {
    on<LoadHome>(_onLoadHome);
    on<ChangePage>((event, emit) async => emit(HomeLoaded(event.page)));
  }

  Future<void> _onLoadHome(
    LoadHome event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoaded(TablesScreen()));
  }
}
