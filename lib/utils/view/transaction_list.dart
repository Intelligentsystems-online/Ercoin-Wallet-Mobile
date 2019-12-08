import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/utils/service/common/date_util.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(Transaction) onTransactionPressed;

  final _dateUtil = DateUtil();

  TransactionList({this.transactions, this.onTransactionPressed});

  @override
  Widget build(BuildContext context) => ListView.builder(
      shrinkWrap: true,
      itemCount: transactions.length,
      itemBuilder: (context, index) => _transactionRow(transactions[index])
  );

  Widget _transactionRow(Transaction transaction) => GestureDetector(
    onTap: () => onTransactionPressed(transaction),
    child: Card(
      child: ListTile(
        title: Text(transaction.message),
        subtitle: _subtitleRow(transaction)
      ),
    ),
  );

  Widget _subtitleRow(Transaction transaction) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(_dateUtil.dateTimeFrom(transaction.timestamp)),
      _transactionValueLabel(transaction)
    ],
  );

  Widget _transactionValueLabel(Transaction transaction) =>
      Text(transaction.coins.toString() + " ERC");
}
