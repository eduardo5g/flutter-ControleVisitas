// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class ChipsTile extends StatelessWidget {
  ChipsTile({
    Key key,
    this.label,
    this.defaultTools,
    this.tools,
    this.selectedTools,
  }) : super(key: key);

  final String label;
  final Set<String> tools;
  final Set<String> selectedTools;
  List<String> defaultTools;

  // Wraps a list of chips into a ListTile for display as a section in the demo.
  @override
  Widget build(BuildContext context) {
    final List<Widget> children = defaultTools.map<Widget>((String name) {
      return FilterChip(
        key: ValueKey<String>(name),
        label: Text(name),
        selected: tools.contains(name) && selectedTools.contains(name),
        onSelected: !tools.contains(name)
            ? null
            : (bool value) {
                if (!value) {
                  selectedTools.remove(name);
                } else {
                  selectedTools.add(name);
                }
              },
      );
    }).toList();
    final List<Widget> cardChildren = <Widget>[
      Container(
        padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
        alignment: Alignment.center,
        child: Text(label, textAlign: TextAlign.start),
      ),
    ];
    if (children.isNotEmpty) {
      cardChildren.add(Wrap(
          children: children.map<Widget>((Widget chip) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: chip,
        );
      }).toList()));
    } else {
      final TextStyle textStyle = Theme.of(context)
          .textTheme
          .caption
          .copyWith(fontStyle: FontStyle.italic);
      cardChildren.add(Semantics(
        container: true,
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
          padding: const EdgeInsets.all(8.0),
          child: Text('None', style: textStyle),
        ),
      ));
    }

    return Card(
      semanticContainer: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: cardChildren,
      ),
    );
  }
}

