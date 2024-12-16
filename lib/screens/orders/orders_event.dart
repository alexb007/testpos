part of 'orders_bloc.dart';

sealed class OrdersEvent {
  const OrdersEvent();
}

final class LoadOrders extends OrdersEvent {
  const LoadOrders();
}
