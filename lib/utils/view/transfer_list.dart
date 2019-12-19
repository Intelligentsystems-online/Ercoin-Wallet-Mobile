import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransferList extends StatelessWidget {
  final List<Transfer> transferList;
  final Function(Transfer) onTransactionPressed;

  final _formatter =  DateFormat('yyyy-MM-dd HH:mm:ss');

  TransferList({this.transferList, this.onTransactionPressed});

  @override
  Widget build(BuildContext context) => ListView.builder(
      shrinkWrap: true,
      itemCount: transferList.length,
      itemBuilder: (context, index) => _transactionRow(transferList[index])
  );

  Widget _transactionRow(Transfer transfer) => GestureDetector(
    onTap: () => onTransactionPressed(transfer),
    child: Card(
      child: ListTile(
        title: Text(transfer.data.message),
        subtitle: _subtitleRow(transfer)
      ),
    ),
  );

  Widget _subtitleRow(Transfer transfer) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(dateTimeFrom(transfer.data.timestamp)),
      _transactionValueLabel(transfer)
    ],
  );

  Widget _transactionValueLabel(Transfer transfer) =>
      Text(transfer.data.amount.ercoin.toString() + " ERN");

  String dateTimeFrom(DateTime timestamp) {
    final datetime = DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);

    return _formatter.format(datetime);
  }
}
