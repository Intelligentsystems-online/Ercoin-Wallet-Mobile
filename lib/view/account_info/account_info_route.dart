import 'package:ercoin_wallet/interactor/account_info/account_info_interctor.dart';
import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/transaction_list.dart';
import 'package:ercoin_wallet/view/add_account/add_account_route.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountInfoRoute extends StatelessWidget {
  final _interactor = AccountInfoInteractor(); //TODO(DI)

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text("Account info"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _interactor.activeAccountWithBalance(),
        builder: (context, snapshot) => snapshot.hasData ? _accountInfoView(snapshot.data) : Center(child: CircularProgressIndicator())
      )
    );

  Widget _accountInfoView(AccountWithBalance accountWithBalance) => Container(
    child: Column(
      children: <Widget>[
        Text("Account: " + accountWithBalance.account.accountName),
        Text("Balance: " + accountWithBalance.balance.toString() + " MICRO ERCOIN"),
        FutureBuilder(
          future: _interactor.recentTransactions(),
          builder: (ctx, snapshot) =>
            snapshot.hasData ? TransactionList(snapshot.data, (transaction) => _onTransactionPressed(ctx, transaction)) : Container()
        )
      ],
    ),
  );

  _onTransactionPressed(BuildContext context, Transaction transaction) =>
      showDialog(context: context, builder: (context) => prepareAlertDialog(context, transaction));

  AlertDialog prepareAlertDialog(BuildContext context, Transaction transaction) {
    return AlertDialog(
        title: Center(child: Text("Transaction detail")),
        content: Column(
          children: <Widget>[
            Text("Receiver: " + transaction.receiverAddress),
            Text("Sender: " + transaction.senderAddress),
            Text("Coins: " + transaction.coins.toString()),
            Text("Message: " + transaction.message),
            Text("Timestamp: " + transaction.timestamp.toString()),
            FlatButton(
                child: Text("Close", style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
                onPressed: () => Navigator.of(context).pop()
            )
          ],
        )
    );
  }
}