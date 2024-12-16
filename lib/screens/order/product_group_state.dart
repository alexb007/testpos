part of 'product_group_cubit.dart';

@immutable
sealed class ProductGroupState {}

final class ProductGroupInitial extends ProductGroupState {
  final List<Product> products;
  ProductGroupInitial({this.products = const []});
}

final class ProductGroupLoaded extends ProductGroupState {
  final List<Product> products;
  ProductGroupLoaded({this.products = const []});
}
