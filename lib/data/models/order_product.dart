import 'package:testorders/data/models/product.dart';
import 'package:testorders/data/repositories/product_repository.dart';

class OrderProduct {
  int? id;
  int orderId;
  int productId;
  Product? product;
  double amount;
  DateTime ordered;
  DateTime? returned;

  OrderProduct(this.id, this.orderId, this.productId, this.amount, this.ordered,
      this.product,
      {this.returned});

  Map<String, dynamic> toMap() => {
        "id": id,
        "productId": productId,
        "orderId": orderId,
        "amount": amount,
        "ordered": ordered.toIso8601String(),
        "returned": returned?.toIso8601String(),
      };

  factory OrderProduct.fromMap(Map<String, dynamic> map,
          {String? prefix = ""}) =>
      OrderProduct(
        map["${prefix}id"],
        map["${prefix}orderId"],
        map["${prefix}productId"],
        map["${prefix}amount"],
        DateTime.parse(map["${prefix}ordered"]),
        Product.fromMap(map, prefix: "${prefix}p__"),
        returned: DateTime.tryParse(map["${prefix}returned"] ?? ""),
      );

  static Future<OrderProduct> serialize(Map<String, dynamic> map) async {
    OrderProduct orderProduct = OrderProduct.fromMap(map);

    final product =
        await ProductRepository().fetchProductById(map["productId"]);

    orderProduct.product = product;
    return Future.value(orderProduct);
  }

  OrderProduct copyWith({
    int? orderId,
    double? amount,
  }) {
    return OrderProduct(
      id,
      orderId ?? this.orderId,
      productId,
      amount ?? this.amount,
      ordered,
      product,
      returned: returned,
    );
  }
}
