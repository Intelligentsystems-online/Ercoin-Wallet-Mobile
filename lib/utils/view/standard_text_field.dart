import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StandardTextField extends StatelessWidget {
  final Function(String) onChanged;

  const StandardTextField(this.onChanged);

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: (value) => onChanged(value),
    decoration: InputDecoration(
      hintText: "Search",
      prefixIcon: Icon(Icons.search),
      border: standardTextFieldBorder),
  );
}