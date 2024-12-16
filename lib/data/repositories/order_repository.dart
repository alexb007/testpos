import 'package:testorders/data/models/order.dart';
import 'package:testorders/data/models/order_product.dart';

import '../database.dart';

class OrderRepository {
  final dbProvider = AppDatabase.instance;

  // Add a new order
  Future<int> addOrder(Order order) async {
    final db = await dbProvider.database;
    return await db.insert('Order', order.toMap());
  }

  // Fetch all orders
  Future<List<Order>> fetchAllOrders() async {
    final db = await dbProvider.database;
    final result = await db.query('Order');
    return result.map((e) => Order.fromMap(e)).toList();
  }

  // Fetch a specific order by ID
  Future<Order?> fetchOrderById(int id) async {
    final db = await dbProvider.database;
    final result = await db.query(
      'Order',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return await Order.serialize(result.first);
    }
    return null;
  }

  // Fetch a specific order by tableID
  Future<Order?> fetchOrderByTableId(int tableId) async {
    final db = await dbProvider.database;
    final result = await db.rawQuery('''
      SELECT 
        o.id, 
        o.tableId, 
        o.opened,
        o.closed, 
        op.id AS op__id,
        op.orderId AS op__orderId,
        op.productId AS op__productId,
        op.amount AS op__amount,
        op.ordered AS op__ordered,
        op.returned AS op__returned,
        p.id AS op__p__id,
        p.title AS op__p__title,
        p.price AS op__p__price,
        p.productGroupId AS op__p__productGroupId,
        pg.id AS op__p__pg__id,
        pg.title AS op__p__pg__title
      FROM "Order" o
      LEFT JOIN OrderProduct op ON o.id = op.orderId
      LEFT JOIN Product p ON op.productId = p.id
      LEFT JOIN ProductGroup pg ON p.productGroupId = pg.id
      WHERE o.tableId = ? AND o.closed is NULL
    ''', [tableId]);

    if (result.isEmpty) return null;

    // Parsing the Order Data
    final orderData = result.first;
    final order = Order.fromMap(orderData);

    // Parsing the Ordered and Returned Products
    final List<OrderProduct> orderedProducts = [];
    for (var row in result) {
      if (row['op__id'] != null) {
        orderedProducts.add(OrderProduct.fromMap(row, prefix: "op__"));
      }
    }
    order.orderedProducts =
        orderedProducts.where((e) => e.returned == null).toList();
    order.returnedProducts =
        orderedProducts.where((e) => e.returned != null).toList();
    return order;
  }

  // Fetch Order with Products
  Future<Order?> fetchOrderWithProducts(int orderId) async {
    final db = await dbProvider.database;

    // Query to fetch Order and join with OrderProduct and Product tables
    final result = await db.rawQuery('''
      SELECT 
        o.id, 
        o.tableId, 
        o.opened,
        o.closed, 
        op.id AS op__id,
        op.orderId AS op__orderId,
        op.productId AS op__productId,
        op.amount AS op__amount,
        op.ordered AS op__ordered,
        op.returned AS op__returned,
        p.id AS op__p__id,
        p.title AS op__p__title,
        p.price AS op__p__price,
        p.productGroupId AS op__p__productGroupId,
        pg.id AS op__p__pg__id,
        pg.title AS op__p__pg__title
      FROM "Order" o
      LEFT JOIN OrderProduct op ON o.id = op.orderId
      LEFT JOIN Product p ON op.productId = p.id
      LEFT JOIN ProductGroup pg ON p.productGroupId = pg.id
      WHERE o.id = ?
    ''', [orderId]);

    if (result.isEmpty) return null;

    // Parsing the Order Data
    final orderData = result.first;
    final order = Order.fromMap(orderData);

    // Parsing the Ordered and Returned Products
    final List<OrderProduct> orderedProducts = [];
    for (var row in result) {
      orderedProducts.add(OrderProduct.fromMap(row, prefix: "op__"));
    }
    order.orderedProducts =
        orderedProducts.where((e) => e.returned == null).toList();
    order.returnedProducts =
        orderedProducts.where((e) => e.returned != null).toList();
    return order;
  }

  // Update an order
  Future<int> updateOrder(Order order) async {
    final db = await dbProvider.database;
    return await db.update(
      'Order',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  // Delete an order
  Future<int> deleteOrder(int id) async {
    final db = await dbProvider.database;
    return await db.delete(
      'Order',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fetch orders with their associated order products
  Future<List<Map<String, dynamic>>> fetchOrdersWithProducts() async {
    final db = await dbProvider.database;

    final result = await db.rawQuery('''
      SELECT 
        o.id AS orderId,
        o.tableId,
        o.opened,
        o.closed,
        op.id AS orderProductId,
        op.productId,
        op.amount,
        op.ordered,
        op.returned
      FROM "Order" o
      LEFT JOIN OrderProduct op ON o.id = op.orderId
      ORDER BY o.id;
    ''');

    return result;
  }

  // Add an order along with its products in a transaction
  Future<void> addOrderWithProducts(
      Order order, List<OrderProduct> products) async {
    final db = await dbProvider.database;

    await db.transaction((txn) async {
      // Insert order and retrieve its ID
      int orderId = await txn.insert('Order', order.toMap());

      // Insert each order product
      for (var product in products) {
        await txn.insert(
            'OrderProduct', product.copyWith(orderId: orderId).toMap());
      }
    });
  }
}
