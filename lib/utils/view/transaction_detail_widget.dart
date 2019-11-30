
import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/utils/DateUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionDetailWidget extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailWidget(this.transaction);

  @override
  Widget build(BuildContext ctx) => Column(
    children: <Widget>[
      Text("Receiver: " + transaction.receiverAddress),
      Text("Sender: " + transaction.senderAddress),
      Text("Coins: " + transaction.coins.toString()),
      Text("Message: " + transaction.message),
      Text("Timestamp: " + DateUtil.dateTimeFrom(transaction.timestamp).toString()),
      FlatButton(
          child: Text("Close", style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
          onPressed: () => Navigator.of(ctx).pop()
      )
    ],
  );
}