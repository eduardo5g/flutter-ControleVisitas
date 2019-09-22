// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:controle_visitas/models/citizen.dart';
import 'package:controle_visitas/utils/citizen_helper.dart';
import 'package:intl/intl.dart';

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
  static var _priorities = ['Não visitada', 'Visitada'];

  CitizenHelper helper = CitizenHelper();

  String appBarTitle;
  Citizen citizen;

  bool switchOn = false;

  void _onSwitchChanged(bool value) {
    switchOn = false;
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  CitizenDetailState(this.citizen, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    bool _isResposability = false;

    nameController.text = citizen.name;
    descriptionController.text = citizen.dateNyver.toString();

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
                ListTile(
                  title: DropdownButton(
                      items: _priorities.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      style: textStyle,
                      value: getPriorityAsString(citizen.priority),
                      onChanged: (valueSelectedByUser) {
                        setState(() {
                          debugPrint('User selected $valueSelectedByUser');
                          updatePriorityAsInt(valueSelectedByUser);
                        });
                      }),
                ),
                new CheckboxListTile(
                  value: _isResposability,
                  onChanged: (bool newValue) {
                    setState(() {
                      print(newValue);
                      _isResposability = newValue;
                      citizen.responsability = newValue? 0 : 1;
                    });
                  },
                  title: Text('Responsavel', style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                ),
                // Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: nameController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                // Fourth Element
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

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  // Update the name of Citizen object
  void updateTitle() {
    citizen.name = nameController.text;
  }

  // Update the description of Citizen object
  void updateDescription() {
    citizen.dateNyver = descriptionController.text;
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
