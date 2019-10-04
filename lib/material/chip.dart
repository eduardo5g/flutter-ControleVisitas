// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class ChipsTile extends StatelessWidget {
  const ChipsTile({
    Key key,
    this.label,
    this.children,
  }) : super(key: key);

  final String label;
  final List<Widget> children;

  // Wraps a list of chips into a ListTile for display as a section in the demo.
  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
            alignment: Alignment.center,
            child: Text(
              label,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (children.isNotEmpty)
            Wrap(
              children: children.map<Widget>((Widget chip) {
                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: chip,
                );
              }).toList(),
            )
          else
            Semantics(
              container: true,
              child: Container(
                alignment: Alignment.center,
                constraints:
                    const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
                padding: const EdgeInsets.all(8.0),
                child: Text('None',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontStyle: FontStyle.italic)),
              ),
            ),
        ],
      ),
    );
  }
}
