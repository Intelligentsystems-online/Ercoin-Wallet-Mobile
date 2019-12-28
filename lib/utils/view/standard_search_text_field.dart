import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/material.dart';

class StandardSearchTextField extends StatelessWidget {
  final Function(String) onChanged;

  const StandardSearchTextField(this.onChanged);

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: (value) => onChanged(value),
    style: TextStyle(fontSize: 16.0),
    textInputAction: TextInputAction.search,
    decoration: InputDecoration(
        hintText: "Search",
        contentPadding: standardTextFieldContentPadding,
        suffixIcon: Icon(Icons.search),
        border: standardTextFieldBorder
    ),
  );
}
