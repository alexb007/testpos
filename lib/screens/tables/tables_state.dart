part of 'tables_bloc.dart';

sealed class TablesState {
  const TablesState();
}

final class TablesLoading extends TablesState {
  const TablesLoading();
}

final class TablesLoaded extends TablesState {
  final List<TableModel> tables;
  const TablesLoaded(this.tables);
}
