
import 'package:ercoin_wallet/model/Transaction.dart';
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
      Text("Timestamp: " + _dateTimeFrom(transaction.timestamp).toString()),
      FlatButton(
          child: Text("Close", style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
          onPressed: () => Navigator.of(ctx).pop()
      )
    ],
  );

  DateTime _dateTimeFrom(int timestamp) => new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
}