import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testorders/data/models/table.dart';
import 'package:testorders/data/repositories/table_repository.dart';

part 'tables_event.dart';
part 'tables_state.dart';

class TablesBloc extends Bloc<TablesEvent, TablesState> {
  TablesBloc() : super(const TablesLoading()) {
    on<LoadTables>(_onLoadHome);
  }

  Future<void> _onLoadHome(
    LoadTables event,
    Emitter<TablesState> emit,
  ) async {
    final tables = await TableRepository().fetchAllTables();
    emit(TablesLoaded(tables));
  }
}
