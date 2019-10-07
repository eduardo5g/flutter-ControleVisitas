// import 'package:flutter/scheduler.dart';

class Saude {

	int _id;
	String _name;

	Saude(this._name);

	Saude.withId(this._id, this._name);

	int get id => _id;

	String get name => _name;

	set name(String newName) {
		if (newName.length <= 255) {
			this._name = newName;
		}
	}

	// Convert a Saude object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['name'] = name;
		return map;
	}

	// Extract a Saude object from a Map object
	Saude.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._name = map['name'];
	}
}
