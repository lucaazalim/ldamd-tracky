import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:mobile/modules/common/data/order.dart';
import 'package:mobile/modules/common/data/enum/order_status.dart';

class OrderDTO {
  final int? id;
  final String status;

  OrderDTO({this.id, required this.status});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
    };
  }

}

class DatabaseService {
  static Database? _database;
  static const String _dbName = 'app_database.db';
  static const String _tableOrder = 'orders';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, _dbName);

    return await openDatabase(path, version: 1,onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $_tableOrder(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          status TEXT
        )
      ''');

      final String jsonString = await rootBundle.loadString('assets/mock/data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<dynamic> orders = jsonData['orders'];

      for (var order in orders) {
        await db.insert(_tableOrder, {
          'id': order['id'],
          'status': order['status'],
        });
      }
    });

  }

  Future<void> updateOrderStatusById(int orderId, OrderStatus status) async {
    final db = await database;
    await db.update(
      _tableOrder,
      {'status': status.toJson()},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  Future<OrderDTO?> getOrderById(int orderId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _tableOrder,
      where: 'id = ?',
      whereArgs: [orderId],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return OrderDTO(
        id: map['id'] as int,
        status: map['status'] as String,
      );
    } else {
      return null;
    }
  }


}