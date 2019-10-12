// import 'package:controle_visitas/material/simple_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/cupertino.dart';
/** DATABASES */
import 'package:controle_visitas/utils/database_helper.dart';
import 'package:controle_visitas/utils/citizen_helper.dart';
import 'package:controle_visitas/utils/saude_helper.dart';
/** MODELS */
import 'package:controle_visitas/models/citizen.dart';
import 'package:controle_visitas/models/saude.dart';
/** CONTROLS */
import 'package:controle_visitas/material/chip.dart';
import 'package:controle_visitas/material/radio_button_group.dart';
import 'package:controle_visitas/material/grouped_buttons_orientation.dart';


class CitizenDetail extends StatefulWidget {
  final String appBarTitle;
  final Citizen citizen;

  CitizenDetail(this.citizen, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return CitizenDetailState(this.citizen, this.appBarTitle);
  }
}

class CitizenDetailState extends State<CitizenDetail> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  CitizenHelper citizenHelper = CitizenHelper();
  SaudeHelper saudeHelper = SaudeHelper();

  Citizen citizen;
  int citizenIdent;

  String _picked = 'Masculino';

  String appBarTitle;

  TextEditingController nameController = TextEditingController();
  TextEditingController susController = TextEditingController();
  TextEditingController maeController = TextEditingController();
  TextEditingController paiController = TextEditingController();

  TextEditingController nascimentoController = TextEditingController();
  DateTime dateNyver = DateTime.now();

  // Objeto do Citizen
  CitizenDetailState(this.citizen, this.appBarTitle);

  // Valores do check da saude
  List<Saude> saudeList;
  List<bool> saudeValue;

  @override
  Widget build(BuildContext context) {
    if (citizen == null) getCitizen();
    nameController.text = citizen.name;
    susController.text = citizen.sus;
    maeController.text = citizen.mae;
    paiController.text = citizen.pai;
    if( DateTime.tryParse(citizen.dateNyver)!=null)
    dateNyver = DateTime.parse(citizen.dateNyver);
    _picked = citizen.sexo;
    TextStyle textStyle = Theme.of(context).textTheme.title;

    if (saudeList == null) {
      saudeList = List<Saude>();
      updateListView();
    }
    String cAvatarT = '';
    Color cAvatarC = Colors.transparent;
    final List<Widget> filterChips = saudeList.map<Widget>((Saude s) {
      return FilterChip(
        avatar: CircleAvatar(
          child: Text(cAvatarT),
          backgroundColor: cAvatarC,
        ),
        key: ValueKey<int>(s.id - 1),
        label: Text(s.name),
        backgroundColor: Colors.redAccent,
        selectedColor: Colors.greenAccent,
        shape: StadiumBorder(side: BorderSide()),
        selected: saudeValue[s.id - 1],
        onSelected: (bool value) {
          setState(() {
            // if (value) {
            //   cAvatarT = '';
            //   cAvatarC = Colors.transparent;
            // } else {
            //   cAvatarT = 'X';
            //   cAvatarC = Colors.redAccent;
            // }
            saudeValue[s.id - 1] = value;
          });
        },
      );
    }).toList();
    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                /** SE RESPONSAVEL */
                ListTile(
                  title: Text('Responsavel'),
                  trailing: CupertinoSwitch(
                    value: (citizen.responsability == 0 ||
                            citizen.responsability == null)
                        ? false
                        : true,
                    onChanged: (bool value) {
                      setState(() {
                        citizen.responsability = (value) ? 1 : 0;
                      });
                    },
                  ),
                ),
                /** NOME */
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: TextField(
                    controller: nameController,
                    style: textStyle,
                    onChanged: (value) {
                      citizen.name = value;
                    },
                    decoration: InputDecoration(
                        labelText: 'Nome',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                /** SEXO */
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: RadioButtonGroup(
                    orientation: GroupedButtonsOrientation.HORIZONTAL,
                    margin: const EdgeInsets.only(left: 1.0),
                    onSelected: (String selected) => setState(() {
                      _picked = selected;
                      citizen.sexo = _picked;
                    }),
                    labels: <String>[
                      "Masculino",
                      "Feminino",
                    ],
                    picked: _picked,
                    itemBuilder: (Radio rb, Text txt, int i) {
                      return Row(
                        children: <Widget>[
                          // Icon(Icons.public),
                          rb,
                          txt,
                        ],
                      );
                    },
                  ),
                ),
                /** SUS */
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 15,
                    controller: susController,
                    style: textStyle,
                    onChanged: (value) {
                      citizen.sus = value;
                    },
                    decoration: InputDecoration(
                        labelText: 'SUS',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                /** NASCIMENTO */
                _buildDatePicker(context),
                /** MAE */
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: TextField(
                    controller: maeController,
                    style: textStyle,
                    onChanged: (value) {
                      citizen.mae = value;
                    },
                    decoration: InputDecoration(
                        labelText: 'Mãe',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                /** Pai */
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: TextField(
                    controller: paiController,
                    style: textStyle,
                    onChanged: (value) {
                      citizen.pai = value;
                    },
                    decoration: InputDecoration(
                        labelText: 'Pai',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                /** SAUDE */
                ChipsTile(label: 'Saúde', children: filterChips),
                /**  Bottom SAVE/CANCEL */
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Salvar',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Cancelar',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _cancel();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        citizen.priority = 1;
        break;
      case 'Low':
        citizen.priority = 2;
        break;
    }
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    citizen.dateNyver = DateFormat.yMMMd().format(DateTime.now());
    String _saude;
    for (int i = 0; i <= saudeValue.length - 1; i++) {
      if (saudeValue[i] == true) {
        if (_saude == null)
          _saude = saudeList[i].id.toString();
        else
          _saude = _saude + ',' + saudeList[i].id.toString();
      }
    }
    citizen.saude = _saude;

    int result;
    if (citizen.id != null) {
      // Case 1: Update operation
      result = await citizenHelper.updateCitizen(citizen);
    } else {
      // Case 2: Insert Operation
      result = await citizenHelper.insertCitizen(citizen);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Citizen Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Citizen');
    }
  }

  void _cancel() async {
    moveToLastScreen();
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return _buildBottomPicker(
              CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: dateNyver,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() => dateNyver = newDateTime);
                },
              ),
            );
          },
        );
      },
      child: _buildMenu(<Widget>[
        const Text('Data de Nascimento'),
        Text(
          DateFormat('dd/MMMM/y').format(dateNyver),
          style: const TextStyle(color: CupertinoColors.inactiveGray),
        ),
      ]),
    );
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 216.0,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 26.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  Widget _buildMenu(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        border: const Border(
          top: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
          bottom: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
        ),
      ),
      height: 44.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(String name, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(name),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void getCitizen() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Citizen>> _listCitizen =
          citizenHelper.getCitizenList(citizenIdent);
      _listCitizen.then((_citizen) {
        setState(() {
          this.citizen = _citizen[0];
        });
      });
    });
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Saude>> saudeListFuture = saudeHelper.getSaudeList();
      saudeListFuture.then((saudeList) {
        setState(() {
          debugPrint(saudeList.toString());
          if (saudeList.length > 1) {
            this.saudeList = saudeList;
            /** CARREGAR ESTADO DE SAUDE */
            this.saudeValue =
                List<bool>.filled(saudeList.length, false, growable: true);
            if (citizen.saude != null) {
              List<String> _tSaude = citizen.saude.toString().split(",");
              for (var i = 0; i < _tSaude.length; i++) {
                this.saudeValue[int.parse(_tSaude[i]) - 1] = true;
              }
            }
          } else {
            saudeHelper.insertSaude(Saude('Gestante'));
            saudeHelper.insertSaude(Saude('Diabetes'));
            saudeHelper.insertSaude(Saude('Hipertensão'));
            saudeHelper.insertSaude(Saude('Domicialiado/Acamado'));
            saudeHelper.insertSaude(Saude('Tuberculose'));
            saudeHelper.insertSaude(Saude('HIV'));
            saudeHelper.insertSaude(Saude('Cancer'));
            saudeHelper.insertSaude(Saude('Obeso'));
            this.updateListView();
          }
        });
      });
    });
  }
}
