import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('restaurant1.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE 'Table' (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE 'ProductGroup' (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE 'Product' (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      price REAL NOT NULL,
      productGroupId INTEGER,
      FOREIGN KEY (productGroupId) REFERENCES ProductGroup (id)
    )
    ''');

    await db.execute('''
    CREATE TABLE 'Order' (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tableId INTEGER,
      opened TEXT NOT NULL,
      closed TEXT,
      FOREIGN KEY (tableId) REFERENCES 'Table' (id)
    )
    ''');

    await db.execute('''
    CREATE TABLE 'OrderProduct' (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      orderId INTEGER,
      productId INTEGER,
      amount REAL NOT NULL,
      ordered TEXT NOT NULL,
      returned TEXT,
      FOREIGN KEY (orderId) REFERENCES 'Order' (id),
      FOREIGN KEY (productId) REFERENCES 'Product' (id)
    )
    ''');

    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    // Insert Tables
    await db.insert('Table', {'title': 'Table 1'});
    await db.insert('Table', {'title': 'Table 2'});
    await db.insert('Table', {'title': 'Table 3'});

    // Insert Product Groups
    await db.insert('ProductGroup', {'title': 'Food'});
    await db.insert('ProductGroup', {'title': 'Drinks'});
    await db.insert('ProductGroup', {'title': 'Desserts'});

    // Insert Products
    await db.insert(
        'Product', {'title': 'Burger', 'price': 5.99, 'productGroupId': 1});
    await db.insert(
        'Product', {'title': 'Pizza', 'price': 8.99, 'productGroupId': 1});
    await db.insert(
        'Product', {'title': 'Coke', 'price': 1.99, 'productGroupId': 2});
    await db.insert(
        'Product', {'title': 'Ice Cream', 'price': 2.99, 'productGroupId': 3});

    // Insert Orders
    await db.insert('Order', {
      'tableId': 1,
      'opened': DateTime.now().toIso8601String(),
    });

    // Insert Order Products (associated with the order)
    await db.insert('OrderProduct', {
      'orderId': 1,
      'productId': 1,
      'amount': 2,
      'ordered': DateTime.now().toIso8601String(),
    }); // 2 Burgers
    await db.insert('OrderProduct', {
      'orderId': 1,
      'productId': 3,
      'amount': 1,
      'ordered': DateTime.now().toIso8601String(),
    }); // 1 Coke
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
