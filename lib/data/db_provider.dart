import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:library_app/data/db_constants.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider instance = DBProvider._();

  static Database _database;
  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDB();
    }
    return _database;
  }

  _initDB() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, "Library.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE ${DBConstants.BOOKS_TABLE} ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "date TEXT,"
        "title TEXT,"
        "author TEXT)"
    );
    await db.execute(
      "CREATE TABLE ${DBConstants.STATS_TABLE} ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "year INT,"
        "month INT,"
        "day INT,"
        "count INT)"
    );
  }

  Future<void> insert(String table, Map<String, dynamic> object) async {
    final db = await database;
    await db.insert(table, object);
  }

  Future<int> update(String table, Map<String, dynamic> object) async {
    final db = await database;
    String whereStr = 'id = ?';
    List<dynamic> whereArg = [object['id']];
    return await db.update(table, object, where: whereStr, whereArgs: whereArg);
  }

  Future<Map<String, dynamic>> getById(String table, int id) async {
    final db = await database;
    String whereStr = 'id = ?';
    List<dynamic> whereArg = [id];
    List<Map<String, dynamic>> res = await db.query(table, where: whereStr, whereArgs: whereArg);
    if (res.length == 1) {
      return res.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getListByCols(String table, Map<String, dynamic> cols) async {
    final db = await database;
    String whereStr = '';
    List<dynamic> whereArgs = [];
    cols.forEach((col, value) {
      whereStr += col + ' = ? AND ';
      whereArgs.add(value);
    });
    whereStr = whereStr.substring(0, whereStr.length - 5); // Remove last AND
    
    return await db.query(table, where: whereStr, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> getListGroupBy(String table, String groupBy, [String sumCol = 'count']) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.rawQuery(
      "SELECT $groupBy, sum($sumCol) as tot "
      "FROM $table GROUP BY $groupBy"
    );
    return res;
  }
}