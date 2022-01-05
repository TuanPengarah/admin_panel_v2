import 'dart:io';

import 'package:admin_panel/auth/controller/firebaseAuth_controller.dart';
import 'package:admin_panel/chat/model/chat_model.dart';
import 'package:admin_panel/home/model/suggestion.dart';
import 'package:admin_panel/jobsheet/model/jobsheet_history.dart';
import 'package:admin_panel/notification/model/notification_model.dart';
import 'package:admin_panel/spareparts/model/sparepart_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../price_list/model/pricelist_model.dart';

class DatabaseHelper {
  final _authController = Get.find<AuthController>();
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path =
        join(documentDirectory.path, '${_authController.userUID.value}.db');

    return await openDatabase(path,
        version: 4, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS notification(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      body TEXT,
      tarikh TEXT
      )
      
      ''');
    }

    if (oldVersion == 2) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS chat(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idUser TEXT,
        content TEXT,
        date TEXT,
        whoChat INTEGER
      )
      ''');
      if (oldVersion == 3) {
        await db.execute('''
      CREATE TABLE IF NOT EXISTS priceListCache(
        id PRIMARY KEY,
        model TEXT,
        parts TEXT,
        price INTEGER
      )
      ''');
      }
    }
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
      CREATE TABLE IF NOT EXISTS notification(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      body TEXT,
      tarikh TEXT
      )
      
      ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS chat(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idUser TEXT,
        content TEXT,
        date TEXT,
        whoChat INTEGER
      )
      ''');
    await db.execute('''
      CREATE TABLE priceListCache(
        id PRIMARY KEY,
        model TEXT,
        parts TEXT,
        price INTEGER
      )
      ''');
  }

  ///CACHE PRICE LIST
  Future<List<PriceListModel>> getCachePriceList() async {
    Database db = await instance.database;

    var caching = await db.query('priceListCache');

    List<PriceListModel> getCache = caching.isNotEmpty
        ? caching.map((e) => PriceListModel.fromJson(e)).toList()
        : [];

    return getCache;
  }

  Future<int> addCachePriceList(PriceListModel priceList) async {
    Database db = await instance.database;

    return await db.insert('priceListCache', priceList.toJson());
  }

  Future<int> deleteCachePriceList() async {
    Database db = await instance.database;
    debugPrint('versi sqlite ${await db.getVersion()}');

    return await db.delete('priceListCache');
  }

  ///CHAT
  Future<List<ChatModel>> getChat(String idUser) async {
    Database db = await instance.database;

    var chatting =
        await db.query('chat', where: 'idUser = ?', whereArgs: [idUser]);

    List<ChatModel> chatHistory = chatting.isNotEmpty
        ? chatting.map((e) => ChatModel.fromMap(e)).toList()
        : [];
    return chatHistory;
  }

  Future<int> deletedChat(int id) async {
    Database db = await instance.database;

    return await db.delete('chat', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> addChat(ChatModel chitChat) async {
    Database db = await instance.database;

    return await db.insert('chat', chitChat.toMap());
  }

  ///NOTIFICATION HISTORY
  Future<List<NotificationsModel>> getNotificationHistory() async {
    Database db = await instance.database;

    var history = await db.query('notification', orderBy: 'id DESC');

    List<NotificationsModel> notificationHistory = history.isNotEmpty
        ? history.map((e) => NotificationsModel.fromMap(e)).toList()
        : [];

    return notificationHistory;
  }

  Future<int> addNotificationHistory(NotificationsModel notif) async {
    Database db = await instance.database;

    return await db.insert('notification', notif.toMap());
  }

  Future<int> deleteNotification(int id) async {
    Database db = await instance.database;

    return await db.delete('notification', where: 'id = ?', whereArgs: [id]);
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

  //PARTS
  Future<List<PartsSuggestion>> getPartsSuggestion(String pattern) async {
    Database db = await instance.database;

    var suggest = await db.query('partsSuggestion', orderBy: 'id DESC');

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
    var suggest = await db.query('partsSuggestion', orderBy: 'id DESC');
    List<PartsSuggestion> list = List.generate(suggest.length, (i) {
      var maps = suggest[i];
      print(maps);
      return PartsSuggestion(parts: maps['parts']);
    });
    bool data = list.any((element) => element.parts == partsSuggestion.parts);
    if (data == true) {
      print('dah ada');
      return 0;
    } else {
      print('xde lgi');
      return await db.insert('partsSuggestion', partsSuggestion.toMap());
    }
  }

  //NAMA
  Future<List<NamaSuggestion>> getNamaSuggestion(String pattern) async {
    Database db = await instance.database;

    var suggest = await db.query('nameSuggestion', orderBy: 'id DESC');

    return List.generate(suggest.length, (i) {
      var maps = suggest[i];
      return NamaSuggestion(nama: maps['name']);
    })
        .where((item) =>
            item.nama.toString().toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  Future<int> addNamaSuggestion(NamaSuggestion namaSuggestion) async {
    Database db = await instance.database;
    var suggest = await db.query('nameSuggestion', orderBy: 'id DESC');
    List<NamaSuggestion> list = List.generate(suggest.length, (i) {
      var maps = suggest[i];
      print(maps);
      return NamaSuggestion(nama: maps['name']);
    });
    bool data = list.any((element) => element.nama == namaSuggestion.nama);
    if (data == true) {
      print('dah ada');
      return 0;
    } else {
      print('xde lgi');
      return await db.insert('nameSuggestion', namaSuggestion.toMap());
    }
  }
}
