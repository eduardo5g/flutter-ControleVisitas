import 'package:flutter/material.dart';

class SimpleList extends StatelessWidget {
  final List<String> name;

  const SimpleList(this.name);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: name.map((item) => new DecoratedBox(
        decoration: BoxDecoration(color: Colors.lightBlueAccent),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(item),
        ),
      ),
      ).toList()
    );
  }
}
