import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:controle_visitas/models/rua.dart';
import 'package:controle_visitas/utils/database_helper.dart';

class RuaHelper {
  // static Database _database;
  DatabaseHelper dbHelper = DatabaseHelper();

	static String ruaTable = 'rua_table';
	final String colId = 'id';
	final String colName = 'name';
	final String colDescription = 'description';
  final String colPriority = 'priority';

	// Fetch Operation: Get all rua objects from database
	Future<List<Map<String, dynamic>>> getRuaMapList() async {
		Database db = await dbHelper.database;

//		var result = await db.rawQuery('SELECT * FROM $ruaTable order by $colPriority ASC');
		var result = await db.query(ruaTable, orderBy: '$colPriority ASC');
		return result;
	}

	// Insert Operation: Insert a Rua object to database
	Future<int> insertRua(Rua rua) async {
		Database db = await dbHelper.database;
		var result = await db.insert(ruaTable, rua.toMap());
		return result;
	}

	// Update Operation: Update a Rua object and save it to database
	Future<int> updateRua(Rua rua) async {
		var db =  await dbHelper.database;
		var result = await db.update(ruaTable, rua.toMap(), where: '$colId = ?', whereArgs: [rua.id]);
		return result;
	}

	// Delete Operation: Delete a Rua object from database
	Future<int> deleteRua(int id) async {
		var db =  await dbHelper.database;
		int result = await db.rawDelete('DELETE FROM $ruaTable WHERE $colId = $id');
		return result;
	}

	// Get number of Rua objects in database
	Future<int> getCount() async {
		Database db =  await dbHelper.database;
		List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $ruaTable');
		int result = Sqflite.firstIntValue(x);
		return result;
	}

	// Get the 'Map List' [ List<Map> ] and convert it to 'Rua List' [ List<Rua> ]
	Future<List<Rua>> getRuaList() async {

		var ruaMapList = await getRuaMapList(); // Get 'Map List' from database
		int count = ruaMapList.length;         // Count the number of map entries in db table

    debugPrint(ruaMapList.toString());
		List<Rua> ruaList = List<Rua>();
		// For loop to create a 'Rua List' from a 'Map List'
		for (int i = 0; i < count; i++) {
			ruaList.add(Rua.fromMapObject(ruaMapList[i]));
		}
		return ruaList;
	}
}
