part of 'table_bloc.dart';

sealed class TableEvent {
  const TableEvent();
}

final class LoadTable extends TableEvent {
  final int tableId;
  const LoadTable(this.tableId);
}
