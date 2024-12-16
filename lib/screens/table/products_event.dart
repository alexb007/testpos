part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {
  const ProductsEvent();
}

final class LoadProducts extends ProductsEvent {
  final ProductGroup? productGroup;
  const LoadProducts(this.productGroup);
}

final class SearchProduct extends ProductsEvent {
  final String query;
  const SearchProduct(this.query);
}
