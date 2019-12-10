
import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/utils/service/common/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionDetailsWidget extends StatelessWidget {
  final Transaction transaction;

  final _dateUtil = DateUtil();

  TransactionDetailsWidget(this.transaction);

  @override
  Widget build(BuildContext ctx) => Column(
    children: <Widget>[
      Text("Receiver: " + transaction.receiverAddress),
      Text("Sender: " + transaction.senderAddress),
      Text("Coins: " + transaction.coins.toString()),
      Text("Message: " + transaction.message),
      Text("Timestamp: " + _dateUtil.dateTimeFrom(transaction.timestamp)),
      FlatButton(
          child: Text("Close", style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
          onPressed: () => Navigator.of(ctx).pop()
      )
    ],
  );
}