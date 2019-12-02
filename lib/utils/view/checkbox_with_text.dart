
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckboxWithTextWidget extends StatelessWidget {
  final String text;
  final bool initialValue;
  final Function(bool) onChanged;

  const CheckboxWithTextWidget({this.text, this.initialValue, this.onChanged});

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Checkbox(
        value: initialValue,
        onChanged: onChanged,
      ),
      Expanded(
          child: Text(text)
      )
    ],
  );
}