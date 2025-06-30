import 'dart:io';

import 'package:flutter/services.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:notification_crypto_coins/model/model_coins.dart';

class DatabaseHelper {
  /*static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('assets/coins.db');
    return _database!;
  }*/
  late Database _db;
  initDB() async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, 'database.db');
    var exist = await databaseExists(path);

    if (exist == false) {
      print("Database does not exist, creating a new one");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "coinsData.db"));
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Database already exists");
      //await File(path).delete();
    }
    //
    return await openDatabase(path);
  }

  Future<List<ModelCoins>> getCoins() async {
    _db = await initDB();

    List<Map<String, dynamic>> list = await _db.rawQuery(
      'SELECT * FROM coins ORDER BY id;',
    );
    return list.map((data) => ModelCoins.fromMap(data)).toList();
  }

  Future<void> addCoinNotification(id) async {
    _db = await initDB();
    await _db.rawUpdate('UPDATE coins SET selected=1 WHERE id=?', [id]);
  }

  Future<void> removeCoinNotification(id) async {
    _db = await initDB();
    await _db.rawUpdate('UPDATE coins SET selected=0 WHERE id =?', [id]);
  }

  Future close() async {
    _db = await initDB();
    _db.close();
  }
}
