import 'package:testorders/data/models/product_group.dart';

import '../database.dart';
import '../models/product.dart';

class ProductRepository {
  final dbProvider = AppDatabase.instance;

  // Add Product
  Future<int> addProduct(Product product) async {
    final db = await dbProvider.database;
    return await db.insert('Product', product.toMap());
  }

  Future<Product?> fetchProductById(int id) async {
    final db = await dbProvider.database;

    // Query to fetch Order and join with OrderProduct and Product tables
    final result = await db.rawQuery('''
      SELECT 
        p.id,
        p.title,
        p.price,
        p.productGroupId,
        pg.id AS pg__id,
        pg.title AS pg__title
      FROM "Product" p
      LEFT JOIN ProductGroup pg ON p.productGroupId = pg.id
      WHERE p.id = ?
    ''', [id]);

    if (result.isEmpty) return null;
    return Product.fromMap(result.first);
  }

  // Fetch a specific product by GroupID
  Future<List<Product>> fetchProductsByGroupId(int groupId) async {
    final db = await dbProvider.database;
    final result = await db.rawQuery('''
      SELECT 
        p.id,
        p.title,
        p.price,
        p.productGroupId,
        pg.id AS pg__id,
        pg.title AS pg__title
      FROM "Product" p
      LEFT JOIN ProductGroup pg ON p.productGroupId = pg.id
      WHERE pg.id = ?
    ''', [groupId]);

    if (result.isNotEmpty) {
      return result.map((e) => Product.fromMap(e)).toList();
    }
    return [];
  }

  // Fetch All Products
  Future<List<Product>> fetchProducts() async {
    final db = await dbProvider.database;
    final result = await db.rawQuery('''
      SELECT 
        p.id,
        p.title,
        p.price,
        p.productGroupId,
        pg.id AS pg__id,
        pg.title AS pg__title
      FROM "Product" p
      LEFT JOIN ProductGroup pg ON p.productGroupId = pg.id
    ''', []);
    if (result.isNotEmpty) {
      return result.map((e) => Product.fromMap(e)).toList();
    }
    return [];
  }

  // Fetch All Products
  Future<List<ProductGroup>> fetchProductGroups() async {
    final db = await dbProvider.database;
    final result = await db.query('ProductGroup');
    if (result.isNotEmpty) {
      print(result);
      return result.map((e) => ProductGroup.fromMap(e)).toList();
    }
    return [];
  }

  // Update Product
  Future<int> updateProduct(Product product) async {
    final db = await dbProvider.database;
    return await db.update(
      'Product',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Delete Product
  Future<int> deleteProduct(int id) async {
    final db = await dbProvider.database;
    return await db.delete('Product', where: 'id = ?', whereArgs: [id]);
  }
}
