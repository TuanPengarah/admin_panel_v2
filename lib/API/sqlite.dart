import 'dart:io';

import 'package:admin_panel/jobsheet/model/jobsheet_history.dart';
import 'package:admin_panel/spareparts/model/sparepart_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

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

    await db.execute('''
    CREATE TABLE sparepartsHistory(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    supplier TEXT,
    model TEXT,
    kualitiParts TEXT,
    jenisParts TEXT,
    harga TEXT,
    maklumatParts TEXT,
    tarikh TEXT,
    partsID TEXT
    )
    ''');
  }

  Future<List<JobsheetHistoryModel>> getCustomerHistory() async {
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

  Future<int> addCustomerHistory(JobsheetHistoryModel history) async {
    Database db = await instance.database;
    return await db.insert('jobsheetHistory', history.toMap());
  }

  Future<int> deleteCustomerHistory(int id) async {
    Database db = await instance.database;
    return await db.delete('jobsheetHistory', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateCustomerHistory(JobsheetHistoryModel history) async {
    Database db = await instance.database;
    return await db.update('jobsheetHistory', history.toMap(),
        where: 'id = ?', whereArgs: [history.id]);
  }

  Future<List<Spareparts>> getSparepartsHistory() async {
    Database db = await instance.database;
    print('init query');
    var history = await db.query(
      'sparepartsHistory',
      orderBy: 'id DESC',
    );
    // List<Spareparts> historyList = history.isNotEmpty
    //     ? history.map((c) {
    //         print('data ada');
    //         Spareparts.fromMap(c);
    //       }).toList()
    //     : [];

    return List.generate(history.length, (i) {
      var maps = history[i];
      return Spareparts(
          model: maps['model'],
          jenisSpareparts: maps['jenisParts'],
          supplier: maps['supplier'],
          kualiti: maps['kualitiParts'],
          maklumatSpareparts: maps['maklumatParts'],
          tarikh: maps['tarikh'],
          harga: maps['harga'],
          partsID: maps['partsID']);
    });
  }

  Future<int> addSparepartsHistory(Spareparts history) async {
    Database db = await instance.database;
    return await db.insert('sparepartsHistory', history.toMap());
  }

  Future<int> deleteSparepartsHistory(int id) async {
    Database db = await instance.database;
    return await db
        .delete('sparepartsHistory', where: 'partsID = ?', whereArgs: [id]);
  }

  Future<int> updateSparepartsHistory(Spareparts history) async {
    Database db = await instance.database;
    return await db.update('sparepartsHistory', history.toMap(),
        where: 'id = ?', whereArgs: [history.partsID]);
  }
}
