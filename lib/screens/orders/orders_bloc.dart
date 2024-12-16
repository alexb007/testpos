import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testorders/data/models/order.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(const OrdersLoading()) {
    on<LoadOrders>(_onLoadHome);
  }

  Future<void> _onLoadHome(
    LoadOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoaded([]));
  }
}
