
class Home {

	int _id;
  int _idRua;
	String _number;
	int _visited;
	String _dateVisite;
	int _priority;

	Home(this._idRua, this._number, this._visited, this._dateVisite, this._priority);

	Home.withId(this._id, this._idRua, this._number, this._visited, this._dateVisite, this._priority);

	int get id => _id;
  int get idRua => _idRua;
	String get number => _number;
	int get visited => _visited;
	String get dateVisite => _dateVisite;
	int get priority => _priority;

  set idRua(int idRua) {
			this._idRua = idRua;
	}

	set number(String number) {
		if (number.length <= 255) {
			this._number = number;
		}
	}

	set visited(int newVisited) {
		if (newVisited >= 1 && newVisited <= 2) {
			this._visited = newVisited;
		}
	}

  set dateVisite(String newDate) {
		this._dateVisite = newDate;
	}

	set priority(int newPriority) {
		if (newPriority >= 1 && newPriority <= 2) {
			this._priority = newPriority;
		}
	}


	// Convert a Home object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['id_rua'] = _idRua;
		map['number'] = _number;
		map['visited'] = _visited;
		map['date_visited'] = _dateVisite;
		map['priority'] = _priority;

		return map;
	}

	// Extract a Home object from a Map object
	Home.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._idRua = map['id_rua'];
		this._number = map['number'];
		this._visited = map['visited'];
		this._dateVisite = map['date_visited'];
		this._priority = map['priority'];
	}
}
