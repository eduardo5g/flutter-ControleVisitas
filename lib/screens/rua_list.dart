// import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';

import 'package:controle_visitas/utils/database_helper.dart';

import 'package:controle_visitas/models/rua.dart';
import 'package:controle_visitas/utils/rua_helper.dart';
import 'package:controle_visitas/screens/rua_detail.dart';

class RuaIdent {
  final int id;
  RuaIdent(this.id);
}

class RuaList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RuaListState();
  }
}

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});
  String title;
  IconData icon;
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Home', icon: Icons.home),
  CustomPopupMenu(title: 'Bookmarks', icon: Icons.bookmark),
  CustomPopupMenu(title: 'Settings', icon: Icons.settings),
];

class RuaListState extends State<RuaList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  RuaHelper ruaHelper = RuaHelper();
  List<Rua> ruaList;
  int count = 0;
  // This is the type used by the popup menu below.
  // CustomPopupMenu _selectedChoices = choices[0];

  @override
  Widget build(BuildContext context) {
    if (ruaList == null) {
      ruaList = List<Rua>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Ruas'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              // size: 25,
              color: Colors.white,
            ),
            onPressed: () {
              databaseHelper.deleteDB();
            },
          ),
        ],
      ),
      body: getRuaListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Rua('', 0, ''), 'Add Rua');
        },
        tooltip: 'Add Rua',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getRuaListView() {
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
                  getPriorityColor(this.ruaList[position].priority),
              child: getPriorityIcon(this.ruaList[position].priority),
            ),
            title: Text(
              this.ruaList[position].name,
              style: nameStyle,
            ),
            subtitle: Text(this.ruaList[position].description),
            onTap: () {
              debugPrint("Listing Homes rua: " + this.ruaList[position].name);
              Navigator.of(context).pushNamed('/HomeList',
                  arguments: this.ruaList[position].id.toString());
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.edit,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    debugPrint("Edit Rua: " + this.ruaList[position].name);
                    navigateToDetail(
                        this.ruaList[position], this.ruaList[position].name);
                  },
                ),
                GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    debugPrint("Delete Rua: " + this.ruaList[position].name);
                    _delete(context, ruaList[position]);
                  },
                ),
              ],
            ),
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

  void _delete(BuildContext context, Rua rua) async {
    int result = await ruaHelper.deleteRua(rua.id);
    if (result != 0) {
      _showSnackBar(context, 'Rua Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Rua rua, String name) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RuaDetail(rua, name);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      databaseHelper.createDb(database, 2);
      Future<List<Rua>> ruaListFuture = ruaHelper.getRuaList();
      ruaListFuture.then((ruaList) {
        setState(() {
          this.ruaList = ruaList;
          this.count = ruaList.length;
        });
      });
    });
  }
}
