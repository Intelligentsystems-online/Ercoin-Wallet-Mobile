
import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountDetailWidget extends StatelessWidget {
  final AccountWithBalance accountWithBalance;
  final Function(BuildContext, String) onActivate;

  const AccountDetailWidget(this.accountWithBalance, this.onActivate);

  @override
  Widget build(BuildContext ctx) => Column(
    children: <Widget>[
      Text("Name: " + accountWithBalance.account.accountName),
      Text("Public key: " + accountWithBalance.account.publicKey),
      Text("Balance: " + accountWithBalance.balance.toString()),
      Row(
        children: <Widget>[_activateBtn(ctx), _closeBtn(ctx)]
      )
    ],
  );

  FlatButton _activateBtn(BuildContext ctx) => FlatButton(
      child: Text("Activate", style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
      onPressed: () => onActivate(ctx, accountWithBalance.account.publicKey)
  );

  FlatButton _closeBtn(BuildContext ctx) => FlatButton(
      child: Text("Close", style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
      onPressed: () => Navigator.of(ctx).pop()
  );
}