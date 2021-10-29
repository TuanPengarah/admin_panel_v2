import 'dart:io';

import 'package:admin_panel/home/model/suggestion.dart';
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

    await db.execute('''
    CREATE TABLE modelSuggestion(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    model TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE partsSuggestion(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    parts TEXT
    )
    ''');

    await db.execute('''
      CREATE TABLE nameSuggestion(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
      )
      ''');
    await db.execute('''
      CREATE TABLE rosakSuggestion(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      rosak TEXT
      )
      ''');
  }

  ///CUSTOMER HISTORY

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

  ///SPAREPARTS HISTORY

  Future<List<Spareparts>> getSparepartsHistory() async {
    Database db = await instance.database;
    var history = await db.query(
      'sparepartsHistory',
      orderBy: 'id DESC',
    );
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

  ///SUGGESTION

  //MODEL
  Future<List<ModelSuggestion>> getModelSuggestion(String pattern) async {
    Database db = await instance.database;

    var suggest = await db.query('modelSuggestion', orderBy: 'id DESC');

    return List.generate(suggest.length, (i) {
      var maps = suggest[i];
      return ModelSuggestion(model: maps['model']);
    })
        .where((item) =>
            item.model.toString().toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  Future<int> addModelSuggestion(ModelSuggestion modelSuggestion) async {
    Database db = await instance.database;
    var suggest = await db.query('modelSuggestion', orderBy: 'id DESC');
    List<ModelSuggestion> list = List.generate(suggest.length, (i) {
      var maps = suggest[i];
      return ModelSuggestion(model: maps['model']);
    });
    bool data = list.any((element) => element.model == modelSuggestion.model);
    if (data == true) {
      print('dah ada');
      return 0;
    } else {
      print('xde lgi');
      return await db.insert('modelSuggestion', modelSuggestion.toMap());
    }
  }

  //KEROSAKKAN
  Future<List<RosakSuggestion>> getRosakSuggestion(String pattern) async {
    Database db = await instance.database;

    var suggest = await db.query('rosakSuggestion', orderBy: 'id DESC');

    return List.generate(suggest.length, (i) {
      var maps = suggest[i];
      return RosakSuggestion(rosak: maps['rosak']);
    })
        .where((item) =>
            item.rosak.toString().toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  Future<int> addRosakSuggestion(RosakSuggestion rosakSuggestion) async {
    Database db = await instance.database;
    var suggest = await db.query('modelSuggestion', orderBy: 'id DESC');
    List<RosakSuggestion> list = List.generate(suggest.length, (i) {
      var maps = suggest[i];
      return RosakSuggestion(rosak: maps['rosak']);
    });
    bool data = list.any((element) => element.rosak == rosakSuggestion.rosak);
    if (data == true) {
      print('dah ada');
      return 0;
    } else {
      print('xde lgi');
      return await db.insert('modelSuggestion', rosakSuggestion.toMap());
    }
  }

  //PARTS
  Future<List<PartsSuggestion>> getPartsSuggestion(String pattern) async {
    Database db = await instance.database;

    var suggest = await db.query('rosakSuggestion', orderBy: 'id DESC');

    return List.generate(suggest.length, (i) {
      var maps = suggest[i];
      return PartsSuggestion(parts: maps['parts']);
    })
        .where((item) =>
            item.parts.toString().toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  Future<int> addPartsSuggestion(PartsSuggestion partsSuggestion) async {
    Database db = await instance.database;
    var suggest = await db.query('modelSuggestion', orderBy: 'id DESC');
    List<PartsSuggestion> list = List.generate(suggest.length, (i) {
      var maps = suggest[i];
      return PartsSuggestion(parts: maps['parts']);
    });
    bool data = list.any((element) => element.parts == partsSuggestion.parts);
    if (data == true) {
      print('dah ada');
      return 0;
    } else {
      print('xde lgi');
      return await db.insert('modelSuggestion', partsSuggestion.toMap());
    }
  }

  //NAMA
  Future<List<NamaSuggestion>> getNamaSuggestion(String pattern) async {
    Database db = await instance.database;

    var suggest = await db.query('rosakSuggestion', orderBy: 'id DESC');

    return List.generate(suggest.length, (i) {
      var maps = suggest[i];
      return NamaSuggestion(nama: maps['nama']);
    })
        .where((item) =>
            item.nama.toString().toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  Future<int> addNamaSuggestion(NamaSuggestion namaSuggestion) async {
    Database db = await instance.database;
    var suggest = await db.query('modelSuggestion', orderBy: 'id DESC');
    List<NamaSuggestion> list = List.generate(suggest.length, (i) {
      var maps = suggest[i];
      return NamaSuggestion(nama: maps['nama']);
    });
    bool data = list.any((element) => element.nama == namaSuggestion.nama);
    if (data == true) {
      print('dah ada');
      return 0;
    } else {
      print('xde lgi');
      return await db.insert('modelSuggestion', namaSuggestion.toMap());
    }
  }
}
