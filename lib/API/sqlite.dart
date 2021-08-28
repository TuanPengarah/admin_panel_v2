import 'dart:io';
import 'package:admin_panel/jobsheet/model/jobsheet_history.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'af-fix.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE jobsheetHistory(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    noPhone TEXT,
    email TEXT,
    kerosakkan TEXT,
    password TEXT,
    price TEXT,
    remarks TEXT,
    model TEXT,
    userUID TEXT
    )
    ''');
  }

  Future<List<JobsheetHistoryModel>> getHistory() async {
    Database db = await instance.database;
    var history = await db.query(
      'jobsheetHistory',
      orderBy: 'id DESC',
    );
    List<JobsheetHistoryModel> historyList = history.isNotEmpty
        ? history.map((c) => JobsheetHistoryModel.fromMap(c)).toList()
        : [];
    return historyList;
  }

  Future<int> add(JobsheetHistoryModel history) async {
    Database db = await instance.database;
    return await db.insert('jobsheetHistory', history.toMap());
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete('jobsheetHistory', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(JobsheetHistoryModel history) async {
    Database db = await instance.database;
    return await db.update('jobsheetHistory', history.toMap(),
        where: 'id = ?', whereArgs: [history.id]);
  }
}
