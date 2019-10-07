
class Citizen {

	int _id;
	int _idCasa;
	String _name;
  String _sus;
	String _dateNyver;
  String _saude;
  int _responsability;
	int _priority;

	Citizen(this._idCasa, this._name, this._sus, this._dateNyver, this._saude, this._responsability, this._priority);

	Citizen.withId(this._id, this._idCasa, this._name, this._sus, this._dateNyver, this._saude, this._responsability, this._priority);

	int get id => _id;
	int get idCasa => _idCasa;
	String get name => _name;
  String get sus => _sus;
	String get dateNyver => _dateNyver;
	String get saude => _saude;
  int get responsability => _responsability;
	int get priority => _priority;

	set idCasa(int newIdCasa) {
			this._idCasa = newIdCasa;
	}

	set name(String newName) {
		if (newName.length <= 255) {
			this._name = newName;
		}
	}
	set sus(String newSus) {
		if (newSus.length <= 255) {
			this._name = newSus;
		}
	}

	set dateNyver(String newDate) {
		this._dateNyver = newDate;
	}

	set saude(String newSaude) {
		this._saude = newSaude;
	}

	set responsability(int newResponsability) {
		this._responsability = newResponsability;
	}

	set priority(int newPriority) {
			this._priority = newPriority;
	}

	// Convert a Citizen object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['id_casa'] = _idCasa;
		map['name'] = _name;
		map['date_nyver'] = _dateNyver;
		map['saude'] = _saude;
		map['responsability'] = _responsability;
    map['priority'] = _priority;
		
		return map;
	}

	// Extract a Citizen object from a Map object
	Citizen.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._idCasa = map['id_casa'];
		this._name = map['name'];
		this._dateNyver = map['date_nyver'];
		this._saude = map['saude'];
		this._responsability = map['responsability'];
		this._priority = map['priority'];
	}
}
