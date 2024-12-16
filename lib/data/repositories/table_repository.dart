import '../database.dart';
import '../models/table.dart';

class TableRepository {
  final dbProvider = AppDatabase.instance;

  // Add a new Table
  Future<int> addTable(TableModel table) async {
    final db = await dbProvider.database;
    return await db.insert('Table', table.toMap());
  }

  // Fetch all Tables
  Future<List<TableModel>> fetchAllTables() async {
    final db = await dbProvider.database;
    final result = await db.query('Table');
    return result.map((e) => TableModel.fromMap(e)).toList();
  }

  // Fetch a specific Table by ID
  Future<TableModel?> fetchTableById(int id) async {
    final db = await dbProvider.database;
    final result = await db.query(
      'Table',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return TableModel.fromMap(result.first);
    }
    return null;
  }

  // Update a Table
  Future<int> updateTable(TableModel table) async {
    final db = await dbProvider.database;
    return await db.update(
      'Table',
      table.toMap(),
      where: 'id = ?',
      whereArgs: [table.id],
    );
  }

  // Delete a Table
  Future<int> deleteTable(int id) async {
    final db = await dbProvider.database;
    return await db.delete(
      'Table',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
