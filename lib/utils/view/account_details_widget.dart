import 'package:ercoin_wallet/model/local_account/local_account_details.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountDetailsWidget extends StatelessWidget {
  final LocalAccountDetails localAccountDetails;
  final Function(BuildContext, String) onActivate;

  const AccountDetailsWidget(this.localAccountDetails, this.onActivate);

  @override
  Widget build(BuildContext ctx) => Column(
    children: <Widget>[
      Text("Name: " + localAccountDetails.localAccount.namedAddress.name),
      Text("Public key: " + localAccountDetails.localAccount.namedAddress.address.publicKey),
      Text("Balance: " + localAccountDetails.balance.toString()),
      Row(
        children: <Widget>[_activateBtn(ctx), _closeBtn(ctx)]
      )
    ],
  );

  FlatButton _activateBtn(BuildContext ctx) => FlatButton(
      child: Text("Activate", style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
      onPressed: () => onActivate(ctx, localAccountDetails.localAccount.namedAddress.address.publicKey)
  );

  FlatButton _closeBtn(BuildContext ctx) => FlatButton(
      child: Text("Close", style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
      onPressed: () => Navigator.of(ctx).pop()
  );
}