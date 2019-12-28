import 'package:ercoin_wallet/utils/view/values.dart';

import 'package:flutter/material.dart';

class StandardTextBox extends StatelessWidget {
  final String value;
  final String labelText;
  final Icon suffixIcon;
  final Function() onSuffixPressed;
  
  const StandardTextBox({
    @required this.value, 
    @required this.labelText, 
    @required this.suffixIcon, 
    @required this.onSuffixPressed
  });
  
  @override
  Widget build(BuildContext ctx) => InputDecorator(
    decoration: InputDecoration(
      labelText: labelText,
      border: standardTextFieldBorder,
      contentPadding: standardTextFieldContentPadding,
      suffixIcon: IconButton(
        icon: suffixIcon,
        onPressed: onSuffixPressed,
      ),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(value, maxLines: 1),
    ),
  );
}
