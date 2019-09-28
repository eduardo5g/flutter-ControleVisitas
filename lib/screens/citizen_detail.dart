import 'package:flutter/material.dart';
import 'package:controle_visitas/models/citizen.dart';
import 'package:controle_visitas/utils/citizen_helper.dart';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:controle_visitas/material/radio_button_group.dart';
import 'package:controle_visitas/material/grouped_buttons_orientation.dart';
import 'package:controle_visitas/material/chip.dart';

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
  String _picked = 'Masculino';

  CitizenHelper helper = CitizenHelper();

  String appBarTitle;
  Citizen citizen;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Objeto do Citizen
  CitizenDetailState(this.citizen, this.appBarTitle);

  // Valores do check da saude
  bool _isSelected=false;
  final List<String> saude = <String>[
    'Gestante',
    'Diabetes',
    'Hipertensão',
    'Acamado/domiciliado',
  ];

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    final List<Widget> tiles = <Widget>[
      const SizedBox(height: 8.0, width: 0.0),
      ChipsTile(label: 'Choose Tools (FilterChip)', defaultTools: saude,),
    ];
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
                        debugPrint(value.toString());
                        citizen.responsability = (value) ? 1 : 0;
                        debugPrint(citizen.responsability.toString());
                        // _isResposability = value;
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
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
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
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      citizen.dateNyver = value;
                    },
                    decoration: InputDecoration(
                        labelText: 'Data de nascimento',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                /** SAUDE */
                // ListView(children: tiles),
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
                            'Save',
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
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
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
    int result;
    if (citizen.id != null) {
      // Case 1: Update operation
      result = await helper.updateCitizen(citizen);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertCitizen(citizen);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Citizen Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Citizen');
    }
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of CitizenList page.
    if (citizen.id == null) {
      _showAlertDialog('Status', 'No Citizen was deleted');
      return;
    }

    // Case 2: User is trying to delete the old citizen that already has a valid ID.
    int result = await helper.deleteCitizen(citizen.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Citizen Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Citizen');
    }
  }

  void _showAlertDialog(String name, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(name),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
