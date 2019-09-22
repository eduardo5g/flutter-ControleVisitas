// import 'package:flutter/scheduler.dart';

class Rua {

	int _id;
	String _name;
	String _description;
  int _priority;

	Rua(this._name, this._priority, [this._description]);

	Rua.withId(this._id, this._name, this._priority, [this._description]);

	int get id => _id;

	String get name => _name;

	String get description => _description;
  int get priority => _priority;

	set name(String newName) {
		if (newName.length <= 255) {
			this._name = newName;
		}
	}

	set description(String newDescription) {
		if (newDescription.length <= 255) {
			this._description = newDescription;
		}
	}

  set priority(int newPriority){
			this._priority = newPriority;
  }

	// Convert a Rua object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['name'] = name;
		map['description'] = _description;
    map['priority'] = _priority;

		return map;
	}

	// Extract a Rua object from a Map object
	Rua.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._name = map['name'];
		this._description = map['description'];
    this._priority = map['priority'];
	}
}
