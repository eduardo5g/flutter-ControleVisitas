import 'package:controle_visitas/utils/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:controle_visitas/models/home.dart';

class HomeHelper {
  DatabaseHelper dbHelper = DatabaseHelper();

  int idRua = 0;
	static String homeTable = 'home_table';
	final String colId = 'id';
	final String colNumber = 'number';
	final String colDescription = 'description';
  final String colPriority = 'priority';

	// Fetch Operation: Get all home objects from database
	Future<List<Map<String, dynamic>>> getHomeMapList(int ruaId) async {
		Database db = await dbHelper.database;

		// var test = await db.rawQuery('SELECT * FROM $homeTable');
    debugPrint(ruaId.toString());
		var result = await db.query(homeTable,
      where: 'id_rua = ?',
      whereArgs: [ruaId],
      orderBy: '$colPriority ASC');
		return result;
	}

	// Insert Operation: Insert a Home object to database
	Future<int> insertHome(Home home) async {
		Database db = await dbHelper.database;
		var result = await db.insert(homeTable, home.toMap());
		return result;
	}

	// Update Operation: Update a Home object and save it to database
	Future<int> updateHome(Home home) async {
		var db = await dbHelper.database;
		var result = await db.update(homeTable, home.toMap(), where: '$colId = ?', whereArgs: [home.id]);
		return result;
	}

	// Delete Operation: Delete a Home object from database
	Future<int> deleteHome(int id) async {
		var db = await dbHelper.database;
		int result = await db.rawDelete('DELETE FROM $homeTable WHERE $colId = $id');
		return result;
	}

	// Get number of Home objects in database
	Future<int> getCount() async {
		Database db = await dbHelper.database;
		List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $homeTable');
		int result = Sqflite.firstIntValue(x);
		return result;
	}

	// Get the 'Map List' [ List<Map> ] and convert it to 'Home List' [ List<Home> ]
	Future<List<Home>> getHomeList(int id) async {
    idRua = id;
		var homeMapList = await getHomeMapList(idRua); // Get 'Map List' from database
    debugPrint(homeMapList.toString());
		int count = homeMapList.length;         // Count the number of map entries in db table

		List<Home> homeList = List<Home>();
		// For loop to create a 'Home List' from a 'Map List'
		for (int i = 0; i < count; i++) {
			homeList.add(Home.fromMapObject(homeMapList[i]));
		}
		return homeList;
	}
}
