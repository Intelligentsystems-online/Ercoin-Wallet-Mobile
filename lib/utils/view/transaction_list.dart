import 'package:ercoin_wallet/model/Transaction.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(Transaction) onTransactionPressed;

  const TransactionList(this.transactions, this.onTransactionPressed);

  @override
  Widget build(BuildContext context) => ListView.builder(
      shrinkWrap: true,
      itemCount: transactions.length,
      itemBuilder: (context, index) => _transactionRow(transactions[index])
  );

  Widget _transactionRow(Transaction transaction) => GestureDetector(
    onTap: () => onTransactionPressed(transaction),
    child: Card(
        child: Row(
          children: <Widget>[
            Text(transaction.message),
            Text(transaction.coins.toString()),
            Text(_dateTimeFrom(transaction.timestamp).toString())
          ],
        )
    ),
  );

  DateTime _dateTimeFrom(int timestamp) => new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
}
