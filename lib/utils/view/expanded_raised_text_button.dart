import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:flutter/material.dart';

class ExpandedRaisedTextButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const ExpandedRaisedTextButton({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext ctx) => ExpandedRow(
    child: RaisedButton(
      child: Text(text),
      onPressed: onPressed,
    ),
  );
}
