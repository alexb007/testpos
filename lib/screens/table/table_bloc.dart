import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testorders/data/models/order.dart';
import 'package:testorders/data/models/table.dart';
import 'package:testorders/data/repositories/order_repository.dart';
import 'package:testorders/data/repositories/table_repository.dart';

part 'table_event.dart';
part 'table_state.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc() : super(const TableLoading()) {
    on<LoadTable>(_onLoadTable);
  }

  Future<void> _onLoadTable(
    LoadTable event,
    Emitter<TableState> emit,
  ) async {
    emit(const TableLoading());
    final table = await TableRepository().fetchTableById(event.tableId);
    final activeOrder =
        await OrderRepository().fetchOrderByTableId(event.tableId);

    if (table == null) {
      emit(const TableNotFound());
    } else {
      emit(TableLoaded(table, activeOrder));
    }
  }
}
