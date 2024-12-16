import 'package:testorders/data/repositories/order_product_repository.dart';

import 'order_product.dart';
import 'table.dart';

class Order {
  int? id;
  int tableId;
  TableModel? table;
  List<OrderProduct> orderedProducts = [];
  List<OrderProduct> returnedProducts = [];
  DateTime opened;
  DateTime? closed;

  Order(
    this.id,
    this.tableId,
    this.opened,
    this.closed,
  );

  Map<String, dynamic> toMap() => {
        "id": id,
        "tableId": tableId,
        "opened": opened.toIso8601String(),
        "closed": closed?.toIso8601String(),
      };

  factory Order.fromMap(Map<String, dynamic> map) => Order(
        map["id"],
        map["tableId"],
        DateTime.parse(map["opened"]),
        DateTime.tryParse(map["closed"] ?? ""),
      );

  static Future<Order> serialize(Map<String, dynamic> map) async {
    Order order = Order.fromMap(map);

    final products =
        await OrderProductRepository().fetchOrderProductsByOrderId(map["id"]);
    order.orderedProducts = products.where((p) => p.returned == null).toList();
    order.returnedProducts = products.where((p) => p.returned != null).toList();
    return Future.value(order);
  }
}
