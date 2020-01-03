import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

class DeleteAlertDialog extends StatelessWidget {
  final Function(BuildContext) _onProceed;

  const DeleteAlertDialog(this._onProceed);

  @override
  Widget build(BuildContext ctx) => AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: standardBorderRadius),
      contentPadding: standardDialogPadding,
      title: Text(
        "Are you sure ?",
        textAlign: TextAlign.center,
        style: Theme.of(ctx).textTheme.title,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buttonsRow(ctx),
        ],
      )
  );

  Widget _buttonsRow(BuildContext ctx) => Row(
    children: <Widget>[
      Expanded(child: _deleteBtn(ctx)),
      SizedBox(width: 8),
      Expanded(child: _closeBtn(ctx))
    ],
  );

  Widget _deleteBtn(BuildContext ctx) => OutlineButton.icon(
      textColor: Colors.red,
      borderSide: BorderSide(color: Theme.of(ctx).primaryColor),
      icon: const Text("Delete"),
      label: const Icon(Icons.delete),
      onPressed: () => _onProceed(ctx),
  );

  Widget _closeBtn(BuildContext ctx) => OutlineButton(
      borderSide: BorderSide(color: Theme.of(ctx).primaryColor),
      child: const Text("Close"),
      onPressed: () =>  Navigator.pop(ctx)
  );
}
