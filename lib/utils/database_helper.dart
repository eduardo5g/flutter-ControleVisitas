import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
// import 'package:controle_visitas/utils/rua_helper.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // if (await File(path).exists()){
    //   Directory(path).deleteSync(recursive: true);
    // }
    // Open/create the database at a given path
    debugPrint('Creating tables');
    var visitasDatabase =
        await openDatabase(await path(), version: 1, onCreate: _createDb);
    return visitasDatabase;
  }
  Future<Database> deleteDB() async {
    debugPrint('Creating tables');
    var visitasDatabase =
        await openDatabase(await path(), version: 1, onCreate: _deleteDb);
    return visitasDatabase;
  }
  Future<String> path() async{
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String _path = directory.path + '/visitas.db';
    return _path;
  }
  static void _deleteDb(Database db, int newVersion) async {    
 		await db.execute('DROP TABLE IF EXISTS home_table');
  }
  static void _createDb(Database db, int newVersion) async {    
    // List<Map<String, dynamic>> checkColumn = await db.query('PRAGMA table_info(rua_table)');
    // debugPrint( checkColumn.toString());
    await db.execute('CREATE TABLE IF NOT EXISTS rua_table (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, priority INTEGER)');
 		await db.execute('CREATE TABLE IF NOT EXISTS home_table ('+
       'id INTEGER PRIMARY KEY AUTOINCREMENT, '+
       'id_rua INTEGER, '+
       'number TEXT, '+ 
       'visited INTEGER, '+
       'date_visited TEXT, '+
       'priority INTEGER)');
 		// await db.execute('DROP TABLE IF EXISTS citizen_table');
 		await db.execute('CREATE TABLE IF NOT EXISTS citizen_table ('+
       'id INTEGER PRIMARY KEY AUTOINCREMENT, '+
       'id_casa INTEGER, '+
       'responsability BYTE, '+
       'name TEXT, '+ 
       'date_nyver TEXT, '+
       'priority INTEGER)');
  }
}
