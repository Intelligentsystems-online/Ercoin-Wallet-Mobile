import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StandardSearchTextField extends StatelessWidget {
  final Function(String) onChanged;

  const StandardSearchTextField(this.onChanged);

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: (value) => onChanged(value),
    style: TextStyle(fontSize: 16.0),
    decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(vertical: 5),
        border: standardTextFieldBorder),
  );
}