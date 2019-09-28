// import 'package:controle_visitas/models/citizen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// Widget CitizenScreen(Citizen citizen) {
//   return Padding(
//     padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
//     child: ListView(
//       children: <Widget>[
//         /** SE RESPONSAVEL */
//         ListTile(
//           title: Text('Responsavel'),
//           trailing: CupertinoSwitch(
//             value:
//                 (citizen.responsability == 0 || citizen.responsability == null)
//                     ? false
//                     : true,
//             onChanged: (bool value) {
//               setState(() {
//                 debugPrint(value.toString());
//                 citizen.responsability = (value) ? 1 : 0;
//                 debugPrint(citizen.responsability.toString());
//                 // _isResposability = value;
//               });
//             },
//           ),
//         ),
//         /** NOME */
//         Padding(
//           padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
//           child: TextField(
//             controller: nameController,
//             style: textStyle,
//             onChanged: (value) {
//               citizen.name = value;
//             },
//             decoration: InputDecoration(
//                 labelText: 'Nome',
//                 labelStyle: textStyle,
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5.0))),
//           ),
//         ),
//         /** SEXO */
//         Padding(
//           padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
//           child: RadioButtonGroup(
//             orientation: GroupedButtonsOrientation.HORIZONTAL,
//             margin: const EdgeInsets.only(left: 1.0),
//             onSelected: (String selected) => setState(() {
//               _picked = selected;
//             }),
//             labels: <String>[
//               "Masculino",
//               "Feminino",
//             ],
//             picked: _picked,
//             itemBuilder: (Radio rb, Text txt, int i) {
//               return Row(
//                 children: <Widget>[
//                   // Icon(Icons.public),
//                   rb,
//                   txt,
//                 ],
//               );
//             },
//           ),
//         ),
//         /** SUS */
//         Padding(
//           padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
//           child: TextField(
//             controller: descriptionController,
//             style: textStyle,
//             onChanged: (value) {
//               debugPrint('Something changed in Description Text Field');
//               citizen.sus = value;
//             },
//             decoration: InputDecoration(
//                 labelText: 'SUS',
//                 labelStyle: textStyle,
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5.0))),
//           ),
//         ),
//         /** NASCIMENTO */
//         Padding(
//           padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
//           child: TextField(
//             controller: descriptionController,
//             style: textStyle,
//             onChanged: (value) {
//               citizen.dateNyver = value;
//             },
//             decoration: InputDecoration(
//                 labelText: 'Data de nascimento',
//                 labelStyle: textStyle,
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5.0))),
//           ),
//         ),
//         /** SAUDE */
//         LabeledCheckbox(
//           label: 'This is the label text',
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           value: _isSelected,
//           onChanged: (bool newValue) {
//             setState(() {
//               _isSelected = newValue;
//             });
//           },
//         ),
//         /**  Bottom SAVE/CANCEL */
//         Padding(
//           padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//           child: Row(
//             children: <Widget>[
//               Expanded(
//                 child: RaisedButton(
//                   color: Theme.of(context).primaryColorDark,
//                   textColor: Theme.of(context).primaryColorLight,
//                   child: Text(
//                     'Save',
//                     textScaleFactor: 1.5,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       debugPrint("Save button clicked");
//                       _save();
//                     });
//                   },
//                 ),
//               ),
//               Container(
//                 width: 5.0,
//               ),
//               Expanded(
//                 child: RaisedButton(
//                   color: Theme.of(context).primaryColorDark,
//                   textColor: Theme.of(context).primaryColorLight,
//                   child: Text(
//                     'Delete',
//                     textScaleFactor: 1.5,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       debugPrint("Delete button clicked");
//                       _delete();
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
