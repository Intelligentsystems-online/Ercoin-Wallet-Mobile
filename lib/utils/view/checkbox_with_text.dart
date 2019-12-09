
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckboxWithTextWidget extends StatelessWidget {
  final String text;
  final bool value;
  final Function(bool) onChanged;

  const CheckboxWithTextWidget({this.text, this.value, this.onChanged});

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Switch(
        value: value,
        onChanged: onChanged,
      ),
      Expanded(
          child: Text(text)
      )
    ],
  );
}
