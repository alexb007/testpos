part of 'order_bloc.dart';

sealed class OrderEvent {
  const OrderEvent();
}

final class LoadOrderProducts extends OrderEvent {
  const LoadOrderProducts();
}

final class PerformOrder extends OrderEvent {
  final Table table;
  final List<OrderProduct> products;
  const PerformOrder(this.table, this.products);
}
