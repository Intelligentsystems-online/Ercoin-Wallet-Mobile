import 'package:ercoin_wallet/model/account_info.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountDetailsWidget extends StatelessWidget {
  final AccountInfo accountInfo;
  final Function(BuildContext, String) onActivate;

  const AccountDetailsWidget(this.accountInfo, this.onActivate);

  @override
  Widget build(BuildContext ctx) => Column(
    children: <Widget>[
      Text("Name: " + accountInfo.account.accountName),
      Text("Public key: " + accountInfo.account.publicKey),
      Text("Balance: " + accountInfo.balance.toString()),
      Row(
        children: <Widget>[_activateBtn(ctx), _closeBtn(ctx)]
      )
    ],
  );

  FlatButton _activateBtn(BuildContext ctx) => FlatButton(
      child: Text("Activate", style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
      onPressed: () => onActivate(ctx, accountInfo.account.publicKey)
  );

  FlatButton _closeBtn(BuildContext ctx) => FlatButton(
      child: Text("Close", style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
      onPressed: () => Navigator.of(ctx).pop()
  );
}