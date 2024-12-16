part of 'tables_bloc.dart';

sealed class TablesEvent {
  const TablesEvent();
}

final class LoadTables extends TablesEvent {
  const LoadTables();
}
