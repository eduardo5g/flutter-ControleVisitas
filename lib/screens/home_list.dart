import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

import 'package:controle_visitas/utils/database_helper.dart';
import 'package:controle_visitas/utils/home_helper.dart';
import 'package:controle_visitas/models/home.dart';
import 'package:controle_visitas/screens/home_detail.dart';

class HomeList extends StatefulWidget {
	@override
  State<StatefulWidget> createState() {
    return HomeListState();
  }
}

int ruaIdent;
class HomeListState extends State<HomeList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
	HomeHelper homeHelper = HomeHelper();
	List<Home> homeList;
	int count = 0;

	@override
  Widget build(BuildContext context) {
    ruaIdent = int.parse(ModalRoute.of(context).settings.arguments);
		if (homeList == null) {
			homeList = List<Home>();
			updateListView();
		}

    return Scaffold(
	    appBar: AppBar(
		    title: Text('Casas'),
	    ),

	    body: getHomeListView(),

	    floatingActionButton: FloatingActionButton(
		    onPressed: () {
		      debugPrint('FAB clicked');
		      navigateToDetail(Home(ruaIdent, '', 0,'', 0), 'Add Casa');
		    },
		    tooltip: 'Add Home',
		    child: Icon(Icons.add),
	    ),
    );
  }

  ListView getHomeListView() {
    		TextStyle nameStyle = Theme.of(context).textTheme.subhead;

		return ListView.builder(
			itemCount: count,
			itemBuilder: (BuildContext context, int position) {
				return Card(
					color: Colors.white,
					elevation: 2.0,
					child: ListTile(
						leading: CircleAvatar(
							backgroundColor: getPriorityColor(this.homeList[position].priority),
							child: getPriorityIcon(this.homeList[position].priority),
						),
						title: Text( this.homeList[position].number, style: nameStyle,),
						subtitle: Text(this.homeList[position].visited.toString()),
						trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.edit,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    debugPrint("Edit casa: " + this.homeList[position].number);
                    navigateToDetail(
                        this.homeList[position], this.homeList[position].number);
                  },
                ),
                GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    debugPrint("Delete casa: " + this.homeList[position].number);
                    _delete(context, homeList[position]);
                  },
                ),
              ],
            ),
						onTap: () {
							debugPrint("Listing Citizens home: " + this.homeList[position].number);
              Navigator.of(context).pushNamed('/CitizenList',
                arguments: this.homeList[position].id.toString());
							// navigateToDetail(this.homeList[position],'Edit Home');
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

	void _delete(BuildContext context, Home home) async {

		int result = await homeHelper.deleteHome(home.id);
		if (result != 0) {
			_showSnackBar(context, 'Home Deleted Successfully');
			updateListView();
		}
	}

	void _showSnackBar(BuildContext context, String message) {

		final snackBar = SnackBar(content: Text(message));
		Scaffold.of(context).showSnackBar(snackBar);
	}

  void navigateToDetail(Home home, String name) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return HomeDetail(home, name);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
  }

  void updateListView() {

		final Future<Database> dbFuture = databaseHelper.initializeDatabase();
		dbFuture.then((database) {

			Future<List<Home>> homeListFuture = homeHelper.getHomeList(ruaIdent);
			homeListFuture.then((homeList) {
				setState(() {
				  this.homeList = homeList;
				  this.count = homeList.length;
				});
			});
		});
  }
}
