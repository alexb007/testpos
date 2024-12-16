part of 'table_bloc.dart';

sealed class TableState {
  const TableState();
}

final class TableLoading extends TableState {
  const TableLoading();
}

final class TableLoaded extends TableState {
  final TableModel table;
  final Order? activeOrder;
  const TableLoaded(this.table, this.activeOrder);
}

final class TableNotFound extends TableState {
  const TableNotFound();
}
