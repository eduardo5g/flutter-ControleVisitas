import 'dart:async';
// import 'package:controle_visitas/screens/home_list.dart';
import 'package:controle_visitas/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:controle_visitas/models/citizen.dart';
import 'package:controle_visitas/utils/citizen_helper.dart';
import 'package:controle_visitas/screens/citizen_detail.dart';
import 'package:sqflite/sqflite.dart';

class CitizenList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CitizenListState();
  }
}

// HomeIdent homeIdent;
int homeIdent;

class CitizenListState extends State<CitizenList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  CitizenHelper citizenHelper = CitizenHelper();
  List<Citizen> citizenList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    homeIdent = int.parse(ModalRoute.of(context).settings.arguments);
    if (citizenList == null) {
      citizenList = List<Citizen>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Moradores'),
      ),
      body: getCitizenListView(),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Citizen(homeIdent, '', '', '', '', 0, 0), 'Add Cidadão');
        },
        tooltip: 'Add Cidadão',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getCitizenListView() {
    TextStyle nameStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  getPriorityColor(this.citizenList[position].priority),
              child: getPriorityIcon(this.citizenList[position].priority),
            ),
            title: Text(
              this.citizenList[position].name,
              style: nameStyle,
            ),
            subtitle: Text(this.citizenList[position].dateNyver.toString()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.edit,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    debugPrint(
                        "Edit casa: " + this.citizenList[position].name);
                    navigateToDetail(this.citizenList[position],
                        this.citizenList[position].name);
                  },
                ),
                GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    debugPrint(
                        "Delete casa: " + this.citizenList[position].name);
                    _delete(context, citizenList[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              navigateToDetail(this.citizenList[position], 'Edit Citizen');
            },
          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Citizen citizen) async {
    int result = await citizenHelper.deleteCitizen(citizen.id);
    if (result != 0) {
      _showSnackBar(context, 'Citizen Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Citizen citizen, String name) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CitizenDetail(citizen, name);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Citizen>> citizenListFuture =
          citizenHelper.getCitizenList(homeIdent, 0);
      citizenListFuture.then((citizenList) {
        setState(() {
          this.citizenList = citizenList;
          this.count = citizenList.length;
        });
      });
    });
  }
}
