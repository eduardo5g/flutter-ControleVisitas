import 'package:flutter/material.dart';
import 'package:controle_visitas/screens/rua_list.dart';
import 'package:controle_visitas/screens/home_list.dart';
import 'package:controle_visitas/screens/citizen_list.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
	@override
  Widget build(BuildContext context) {
    return MaterialApp(
	    title: 'Lista de Ruas',
	    debugShowCheckedModeBanner: false,
	    theme: ThemeData(
		    primarySwatch: Colors.indigo
	    ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new RuaList(),
        '/HomeList': (BuildContext context) => new HomeList(),
        '/CitizenList': (BuildContext context) => new CitizenList(),
      },
      initialRoute: '/',
    );
  }
}