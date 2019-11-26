import 'package:flutter/material.dart';

class ExpandedRow extends StatelessWidget {
  final Widget child;

  const ExpandedRow({this.child});

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Expanded(
            child: child,
          )
        ],
      );
}
