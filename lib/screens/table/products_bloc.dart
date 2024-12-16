import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:testorders/data/models/product.dart';
import 'package:testorders/data/repositories/product_repository.dart';

import '../../data/models/product_group.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final List<ProductGroup> groups = [];
  ProductsBloc() : super(ProductsInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductsLoading());
      if (groups.isEmpty) {
        groups.addAll(await ProductRepository().fetchProductGroups());
      }
      if (event.productGroup != null) {
        emit(
          ProductsLoaded(
            event.productGroup,
            await ProductRepository()
                .fetchProductsByGroupId(event.productGroup!.id),
            groups,
          ),
        );
      } else {
        emit(
          ProductsLoaded(
            null,
            await ProductRepository().fetchProducts(),
            groups,
          ),
        );
      }
    });
  }
}
