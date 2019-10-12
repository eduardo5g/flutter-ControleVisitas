
class Citizen {

	int _id;
	int _idCasa;
  int _responsability;
	String _name;
  String _sus;
  String _sexo;
  String _mae;
  String _pai;
	String _dateNyver;
  String _saude;
	int _priority;

	Citizen(                 this._idCasa, this._name, this._sus, this._sexo, this._mae, this._pai, this._dateNyver, this._saude, this._responsability, this._priority);

	Citizen.withId(this._id, this._idCasa, this._name, this._sus, this._sexo, this._mae, this._pai, this._dateNyver, this._saude, this._responsability, this._priority);

	int get id => _id;
	int get idCasa => _idCasa;
	String get name => _name;
  String get sus => _sus;
  String get sexo => _sexo;
  String get mae => _mae;
  String get pai => _pai;
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
			this._sus = newSus;
		}
	}

	set sexo(String newSexo) {
		if (newSexo.length <= 255) {
			this._sexo = newSexo;
		}
	}

	set mae(String newMae) {
		if (newMae.length <= 255) {
			this._mae = newMae;
		}
	}

	set pai(String newPai) {
		if (newPai.length <= 255) {
			this._pai = newPai;
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
		map['sus'] = _sus;
		map['sexo'] = _sexo;
		map['mae'] = _mae;
		map['pai'] = _pai;
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
		this._sus = map['sus'];
		this._sexo = map['sexo'];
		this._mae = map['mae'];
		this._pai = map['pai'];
		this._dateNyver = map['date_nyver'];
		this._saude = map['saude'];
		this._responsability = map['responsability'];
		this._priority = map['priority'];
	}
}
