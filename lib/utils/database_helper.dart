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
    var visitasDatabase =
        await openDatabase(await path(), version: 2, onCreate: createDb);
    return visitasDatabase;
  }
  void deleteDB(Database db, String _table) async {
    debugPrint('Delete tables :: database_helper->41');
    await db.execute('DROP TABLE IF EXISTS $_table');

  }
  Future<String> path() async{
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String _path = directory.path + '/visitas.db';
    return _path;
  }
   void createDb(Database db, int newVersion) async {    
    // List<Map<String, dynamic>> checkColumn = await db.query('PRAGMA table_info(rua_table)');
    // debugPrint( checkColumn.toString());
    debugPrint('Creating tables :: database_helper->55');
    await db.execute('CREATE TABLE IF NOT EXISTS rua_table (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, priority INTEGER)');
 		await db.execute('CREATE TABLE IF NOT EXISTS home_table ('+
       'id INTEGER PRIMARY KEY AUTOINCREMENT, '+
       'id_rua INTEGER, '+
       'number TEXT, '+ 
       'visited INTEGER, '+
       'date_visited TEXT, '+
       'priority INTEGER)');
    // print('drop table');
 		// await db.rawDelete('DROP TABLE IF EXISTS citizen_table');
 		await db.execute('CREATE TABLE IF NOT EXISTS citizen_table ('+
       'id INTEGER PRIMARY KEY AUTOINCREMENT, '+
       'id_casa INTEGER, '+
       'responsability INTEGER, '+
       'name TEXT, '+ 
       'sus TEXT, '+ 
       'date_nyver TEXT, '+
       'saude TEXT, '+
       'priority INTEGER)');
       addColumn(db, 'citizen_table', 'pai', 'TEXT');
       addColumn(db, 'citizen_table', 'mae', 'TEXT');
    await db.execute('CREATE TABLE IF NOT EXISTS saude_table (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)');
  }
  void addColumn(Database _db, String _table, String _sColumn, String _dataType) async{
    await _db.execute('ALTER TABLE $_table ADD $_sColumn $_dataType');
  }
  // Invalid in  SQLITE
  // void dellColumn(Database _db, String _table, String _column) async{
  //   await _db.execute('ALTER TABLE $_table DROP COLUMN $_column');
  // }
  void dataTypeColumn(Database _db, String _table, String _oldColumn, String _newColumn) async{
    await _db.execute('ALTER TABLE $_table RENAME COLUMN $_oldColumn TO _newColumn');
  }
}
