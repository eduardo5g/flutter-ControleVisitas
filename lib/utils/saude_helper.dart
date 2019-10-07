import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:controle_visitas/models/saude.dart';
import 'package:controle_visitas/utils/database_helper.dart';

class SaudeHelper {
  // static Database _database;
  DatabaseHelper dbHelper = DatabaseHelper();

	static String saudeTable = 'saude_table';
	final String colId = 'id';
	final String colName = 'name';

	// Fetch Operation: Get all saude objects from database
	Future<List<Map<String, dynamic>>> getSaudeMapList() async {
		Database db = await dbHelper.database;

//		var result = await db.rawQuery('SELECT * FROM $saudeTable order by $colPriority ASC');
		var result = await db.query(saudeTable);
		return result;
	}

	// Insert Operation: Insert a Saude object to database
	Future<int> insertSaude(Saude saude) async {
		Database db = await dbHelper.database;
		var result = await db.insert(saudeTable, saude.toMap());
		return result;
	}

	// Update Operation: Update a Saude object and save it to database
	Future<int> updateSaude(Saude saude) async {
		var db =  await dbHelper.database;
		var result = await db.update(saudeTable, saude.toMap(), where: '$colId = ?', whereArgs: [saude.id]);
		return result;
	}

	// Delete Operation: Delete a Saude object from database
	Future<int> deleteSaude(int id) async {
		var db =  await dbHelper.database;
		int result = await db.rawDelete('DELETE FROM $saudeTable WHERE $colId = $id');
		return result;
	}

	// Get number of Saude objects in database
	Future<int> getCount() async {
		Database db =  await dbHelper.database;
		List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $saudeTable');
		int result = Sqflite.firstIntValue(x);
		return result;
	}

	// Get the 'Map List' [ List<Map> ] and convert it to 'Saude List' [ List<Saude> ]
	Future<List<Saude>> getSaudeList() async {

		var saudeMapList = await getSaudeMapList(); // Get 'Map List' from database
		int count = saudeMapList.length;         // Count the number of map entries in db table

    debugPrint(saudeMapList.toString());
		List<Saude> saudeList = List<Saude>();
		// For loop to create a 'Saude List' from a 'Map List'
		for (int i = 0; i < count; i++) {
			saudeList.add(Saude.fromMapObject(saudeMapList[i]));
		}
		return saudeList;
	}
}
