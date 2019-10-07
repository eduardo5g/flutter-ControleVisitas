import 'package:controle_visitas/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:controle_visitas/models/citizen.dart';

class CitizenHelper {
  DatabaseHelper dbHelper = DatabaseHelper();

  int idCasa = 0;
  static String citizenTable = 'citizen_table';
  final String colId = 'id';
  final String colIdCasa = 'id_casa';
  final String colName = 'name';
  final String colDateNyver = 'date_nyver';
  final String colPriority = 'priority';

  // Fetch Operation: Get all citizen objects from database
  Future<List<Map<String, dynamic>>> getCitizenMapList(int casaId, [int responsability=0]) async {
    Database db = await dbHelper.database;
    String sWhere = ( responsability==1 ) ? 'id_casa = ? and responsability = ?':'id_casa = ?';
    List<dynamic> aWhere = ( responsability==1 ) ? [casaId, 1] : [casaId];
    
//		var result = await db.rawQuery('SELECT * FROM $citizenTable order by $colPriority ASC');
    var result = await db.query(citizenTable,
        where: sWhere,
        whereArgs: aWhere,
        orderBy: '$colPriority ASC');
    return result;
  }

  // Insert Operation: Insert a Citizen object to database
  Future<int> insertCitizen(Citizen citizen) async {
    Database db = await dbHelper.database;
    var result = await db.insert(citizenTable, citizen.toMap());
    return result;
  }

  // Update Operation: Update a Citizen object and save it to database
  Future<int> updateCitizen(Citizen citizen) async {
    var db = await dbHelper.database;
    var result = await db.update(citizenTable, citizen.toMap(),
        where: '$colId = ?', whereArgs: [citizen.id]);
    return result;
  }

  // Delete Operation: Delete a Citizen object from database
  Future<int> deleteCitizen(int id) async {
    var db = await dbHelper.database;
    int result =
        await db.rawDelete('DELETE FROM $citizenTable WHERE $colId = $id');
    return result;
  }

  // Get number of Citizen objects in database
  Future<int> getCount() async {
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $citizenTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Citizen List' [ List<Citizen> ]
  Future<List<Citizen>> getCitizenList(int id, [int responsability = 0]) async {
    idCasa = id;
    var citizenMapList =
        await getCitizenMapList(idCasa, responsability); // Get 'Map List' from database
    int count = citizenMapList.length; // Count the number of map entries in db table

    List<Citizen> citizenList = List<Citizen>();
    // For loop to create a 'Citizen List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      citizenList.add(Citizen.fromMapObject(citizenMapList[i]));
    }

    return citizenList;
  }
}
