import 'package:flutter/material.dart';
import 'package:controle_visitas/models/rua.dart';
import 'package:controle_visitas/utils/database_helper.dart';
import 'package:controle_visitas/utils/rua_helper.dart';

class RuaDetail extends StatefulWidget {

	final String appBarTitle;
	final Rua rua;

	RuaDetail(this.rua, this.appBarTitle);

	@override
  State<StatefulWidget> createState() {

    return RuaDetailState(this.rua, this.appBarTitle);
  }
}

class RuaDetailState extends State<RuaDetail> {

	static var _priorities = ['High', 'Low'];

	DatabaseHelper helper = DatabaseHelper();
	RuaHelper ruaHelper = RuaHelper();

	String appBarTitle;
	Rua rua;

	TextEditingController nameController = TextEditingController();
	TextEditingController descriptionController = TextEditingController();

	RuaDetailState(this.rua, this.appBarTitle);

	@override
  Widget build(BuildContext context) {

		TextStyle textStyle = Theme.of(context).textTheme.title;

		nameController.text = rua.name;
		descriptionController.text = rua.description;

    return WillPopScope(

	    onWillPop: () {
	    	// Write some code to control things, when user press Back navigation button in device navigationBar
		    moveToLastScreen();
	    },

	    child: Scaffold(
	    appBar: AppBar(
		    title: Text(appBarTitle),
		    leading: IconButton(icon: Icon(
				    Icons.arrow_back),
				    onPressed: () {
		    	    // Write some code to control things, when user press back button in AppBar
		    	    moveToLastScreen();
				    }
		    ),
	    ),

	    body: Padding(
		    padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
		    child: ListView(
			    children: <Widget>[

			    	// First element
				    ListTile(
					    title: DropdownButton(
							    items: _priorities.map((String dropDownStringItem) {
							    	return DropdownMenuItem<String> (
									    value: dropDownStringItem,
									    child: Text(dropDownStringItem),
								    );
							    }).toList(),

							    style: textStyle,

							    value: getPriorityAsString(rua.priority),

							    onChanged: (valueSelectedByUser) {
							    	setState(() {
							    	  debugPrint('User selected $valueSelectedByUser');
							    	  updatePriorityAsInt(valueSelectedByUser);
							    	});
							    }
					    ),
				    ),

				    // Second Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: nameController,
						    style: textStyle,
						    onChanged: (value) {
						    	updateTitle();
						    },
						    decoration: InputDecoration(
							    labelText: 'Title',
							    labelStyle: textStyle,
							    border: OutlineInputBorder(
								    borderRadius: BorderRadius.circular(5.0)
							    )
						    ),
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
										    borderRadius: BorderRadius.circular(5.0)
								    )
						    ),
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

							    Container(width: 5.0,),

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
				rua.priority = 1;
				break;
			case 'Low':
				rua.priority = 2;
				break;
		}
	}

	// Convert int priority to String priority and display it to user in DropDown
	String getPriorityAsString(int value) {
		String priority;
		switch (value) {
			case 1:
				priority = _priorities[0];  // 'High'
				break;
			case 2:
				priority = _priorities[1];  // 'Low'
				break;
		}
		return priority;
	}

	// Update the name of Rua object
  void updateTitle(){
    rua.name = nameController.text;
  }

	// Update the description of Rua object
	void updateDescription() {
		rua.description = descriptionController.text;
	}

	// Save data to database
	void _save() async {

		moveToLastScreen();

		// rua.date = DateFormat.yMMMd().format(DateTime.now());
		int result;
		if (rua.id != null) {  // Case 1: Update operation
			result = await ruaHelper.updateRua(rua);
		} else { // Case 2: Insert Operation
			result = await ruaHelper.insertRua(rua);
		}

		if (result != 0) {  // Success
			_showAlertDialog('Status', 'Rua Saved Successfully');
		} else {  // Failure
			_showAlertDialog('Status', 'Problem Saving Rua');
		}

	}

	void _delete() async {

		moveToLastScreen();

		// Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
		// the detail page by pressing the FAB of RuaList page.
		if (rua.id == null) {
			_showAlertDialog('Status', 'No Rua was deleted');
			return;
		}

		// Case 2: User is trying to delete the old rua that already has a valid ID.
		int result = await ruaHelper.deleteRua(rua.id);
		if (result != 0) {
			_showAlertDialog('Status', 'Rua Deleted Successfully');
		} else {
			_showAlertDialog('Status', 'Error Occured while Deleting Rua');
		}
	}

	void _showAlertDialog(String name, String message) {

		AlertDialog alertDialog = AlertDialog(
			title: Text(name),
			content: Text(message),
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}

}
