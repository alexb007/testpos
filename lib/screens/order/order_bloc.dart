import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testorders/data/models/order_product.dart';

import '../../data/models/product_group.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const OrderLoading()) {
    on<LoadOrderProducts>(_onLoadProducts);
    on<PerformOrder>(_onPerformOrder);
  }

  Future<void> _onLoadProducts(
    LoadOrderProducts event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoaded([], null));
  }

  Future<void> _onPerformOrder(
    PerformOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoaded([], null));
  }
}
