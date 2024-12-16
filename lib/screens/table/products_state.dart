part of 'products_bloc.dart';

@immutable
sealed class ProductsState {
  const ProductsState();
}

final class ProductsInitial extends ProductsState {}

final class ProductsLoading extends ProductsState {}

final class ProductsLoaded extends ProductsState {
  final ProductGroup? productGroup;
  final List<Product> products;
  final List<ProductGroup> groups;

  const ProductsLoaded(this.productGroup, this.products, this.groups);
}
