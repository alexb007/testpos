part of 'order_bloc.dart';

sealed class OrderState {
  const OrderState();
}

final class OrderLoading extends OrderState {
  const OrderLoading();
}

final class OrderLoaded extends OrderState {
  final List<ProductGroup> productGroups;
  final ProductGroup? currentGroup;
  const OrderLoaded(this.productGroups, this.currentGroup);
}
