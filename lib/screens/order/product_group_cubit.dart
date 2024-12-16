import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:testorders/data/models/product.dart';

import '../../data/models/product_group.dart';

part 'product_group_state.dart';

class ProductGroupCubit extends Cubit<ProductGroupState> {
  final ProductGroup group;
  ProductGroupCubit(this.group) : super(ProductGroupInitial());

  Future<void> loadProducts() async {}
}
