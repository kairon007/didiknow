import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/employee.dart';


class DatabaseHelper {
  static const _databaseName = 'employee_database.db';
  static const _databaseVersion = 1;
  static const _tableName = 'employees';

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  late Database _database;

  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        role TEXT,
        fromDate TEXT,
        toDate TEXT
      )
    ''');
  }

  Future<int> insertEmployee(Employee employee) async {
    final db = await database;
    return await db.insert(
      _tableName,
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Employee>> getEmployees() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Employee(
        id: maps[i]['id'],
        name: maps[i]['name'],
        role: roles.firstWhere((role) => role.value == maps[i]['role']),
        fromDate: DateTime.parse(maps[i]['fromDate']),
        toDate:maps[i]['toDate'] != null ? DateTime.parse(maps[i]['toDate']) : null ,
      );
    });
  }

  Future<int> updateEmployee(Employee employee) async {
    final db = await database;
    return await db.update(
      _tableName,
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<int> deleteEmployee(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}