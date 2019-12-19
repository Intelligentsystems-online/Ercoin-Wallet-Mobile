import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransferDetailsWidget extends StatelessWidget {
  final Transfer transfer;

  final _formatter =  DateFormat('yyyy-MM-dd HH:mm:ss');

  TransferDetailsWidget(this.transfer);

  @override
  Widget build(BuildContext ctx) => Column(
    children: <Widget>[
      Text("Receiver: " + transfer.data.to.publicKey),
      Text("Sender: " + transfer.data.from.publicKey),
      Text("Coins: " + transfer.data.amount.ercoin.toString()),
      Text("Message: " + transfer.data.message),
      Text("Timestamp: " + dateTimeFrom(transfer.data.timestamp)),
      FlatButton(
          child: Text("Close", style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
          onPressed: () => Navigator.of(ctx).pop()
      )
    ],
  );

  String dateTimeFrom(DateTime timestamp) {
    final datetime = DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);

    return _formatter.format(datetime);
  }
}