import 'package:testorders/data/models/order_product.dart';

import '../database.dart';

class OrderProductRepository {
  final dbProvider = AppDatabase.instance;

  // Add a single OrderProduct
  Future<int> addOrderProduct(OrderProduct orderProduct) async {
    final db = await dbProvider.database;
    return await db.insert('OrderProduct', orderProduct.toMap());
  }

  // Add multiple OrderProducts in bulk
  Future<void> addOrderProducts(List<OrderProduct> orderProducts) async {
    final db = await dbProvider.database;

    await db.transaction((txn) async {
      for (var product in orderProducts) {
        await txn.insert('OrderProduct', product.toMap());
      }
    });
  }

  // Fetch all OrderProducts
  Future<List<OrderProduct>> fetchAllOrderProducts() async {
    final db = await dbProvider.database;
    final result = await db.query('OrderProduct');
    return result.map((e) => OrderProduct.fromMap(e)).toList();
  }

  // Fetch OrderProducts by Order ID
  Future<List<OrderProduct>> fetchOrderProductsByOrderId(int orderId) async {
    final db = await dbProvider.database;
    final result = await db.query(
      'OrderProduct',
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
    return result.map((e) => OrderProduct.fromMap(e)).toList();
  }

  // Update an OrderProduct
  Future<int> updateOrderProduct(OrderProduct orderProduct) async {
    final db = await dbProvider.database;
    return await db.update(
      'OrderProduct',
      orderProduct.toMap(),
      where: 'id = ?',
      whereArgs: [orderProduct.id],
    );
  }

  // Delete an OrderProduct by ID
  Future<int> deleteOrderProduct(int id) async {
    final db = await dbProvider.database;
    return await db.delete(
      'OrderProduct',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all OrderProducts associated with an Order ID
  Future<int> deleteOrderProductsByOrderId(int orderId) async {
    final db = await dbProvider.database;
    return await db.delete(
      'OrderProduct',
      where: 'orderId = ?',
      whereArgs: [orderId],
    );
  }
}
