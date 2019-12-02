import 'package:ercoin_wallet/interactor/account_info/account_info_interctor.dart';
import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/transaction_details_widget.dart';
import 'package:ercoin_wallet/utils/view/transaction_list.dart';
import 'package:ercoin_wallet/utils/view/values.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountInfoPage extends StatelessWidget {
  final _interactor = AccountInfoInteractor(); //TODO(DI)

  @override
  Widget build(BuildContext context) => FutureBuilderWithProgress(
      future: _interactor.obtainActiveAccountWithBalance(),
      builder: (AccountWithBalance accountWithBalance) => _accountInfoView(context, accountWithBalance)
  );

  Widget _accountInfoView(BuildContext ctx, AccountWithBalance accountWithBalance) => Container(
    padding: standardPadding,
    child: Column(
      children: <Widget>[
        Text("Account: " + accountWithBalance.account.accountName),
        Text("Balance: " + accountWithBalance.balance.toString() + " MICRO ERCOIN"),
        FutureBuilderWithProgress(
            future: _interactor.obtainRecentTransactions(),
            builder: (List<Transaction> transactions) => TransactionList(transactions, (transaction) => _onTransactionPressed(ctx, transaction))
        )
      ],
    ),
  );

  _onTransactionPressed(BuildContext ctx, Transaction transaction) => showDialog(
      context: ctx,
      builder: (ctx) => prepareAlertDialog(ctx, transaction)
  );

  AlertDialog prepareAlertDialog(BuildContext ctx, Transaction transaction) => AlertDialog(
      title: Center(child: Text("Transaction detail")),
      content: TransactionDetailsWidget(transaction)
  );
}