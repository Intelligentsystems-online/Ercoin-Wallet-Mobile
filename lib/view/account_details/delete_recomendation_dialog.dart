import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

class DeleteRecomendationDialog extends StatelessWidget {
  final Function(BuildContext) _onProceed;

  const DeleteRecomendationDialog(this._onProceed);

  @override
  Widget build(BuildContext ctx) => AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: standardBorderRadius),
      contentPadding: standardDialogPadding,
      title: Text(
        "Backup recommended",
        textAlign: TextAlign.center,
        style: Theme.of(ctx).textTheme.title,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text("Before proceeding make sure that you wrote down access keys. Otherwise you will loose account data."),
          SizedBox(height: 8),
          _buttonsRow(ctx),
        ],
      )
  );

  Widget _buttonsRow(BuildContext ctx) => Row(
    children: <Widget>[
      Expanded(child: _proceedBtn(ctx)),
      SizedBox(width: 8),
      Expanded(child: _closeBtn(ctx))
    ],
  );

  Widget _proceedBtn(BuildContext ctx) => OutlineButton(
      borderSide: BorderSide(color: Theme.of(ctx).primaryColor),
      child: const Text("Continue"),
      onPressed: () => _onProceed(ctx)
  );

  Widget _closeBtn(BuildContext ctx) => OutlineButton(
      borderSide: BorderSide(color: Theme.of(ctx).primaryColor),
      child: const Text("Close"),
      onPressed: () =>  Navigator.pop(ctx)
  );
}
