
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckboxWithTextWidget extends StatelessWidget {
  final String text;
  final bool initialState;
  final Function(bool) onChanged;

  const CheckboxWithTextWidget({this.text, this.initialState, this.onChanged});

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Checkbox(
        value: initialState,
        onChanged: (isChecked) => onChanged(isChecked),
      ),
      Expanded(
          child: Text(text)
      )
    ],
  );
}