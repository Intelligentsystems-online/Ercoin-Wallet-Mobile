import 'package:ercoin_wallet/interactor/account_info/account_info_interctor.dart';
import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/transaction_details_widget.dart';
import 'package:ercoin_wallet/utils/view/transaction_list.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/transfer/select_destination/select_transfer_destination_route.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AccountInfoPage extends StatelessWidget {
  final _interactor = AccountInfoInteractor(); //TODO(DI)

  @override
  Widget build(BuildContext context) => FutureBuilderWithProgress(
      future: _interactor.obtainActiveAccountWithBalance(),
      builder: (AccountWithBalance accountWithBalance) => _accountInfoView(context, accountWithBalance));

  Widget _accountInfoView(BuildContext ctx, AccountWithBalance accountWithBalance) => Container(
        padding: standardPadding,
        child: Column(
          children: <Widget>[
            QrImage(
              data: accountWithBalance.account.publicKey,
              size: 150,
              padding: standardPadding,
            ),
            Text("Account: " + accountWithBalance.account.accountName),
            Text("Balance: " + accountWithBalance.balance.toString() + " ERCOIN"),
            FutureBuilderWithProgress(
              future: _interactor.obtainRecentTransactions(),
              builder: (transactions) => TransactionList(
                transactions: transactions,
                onTransactionPressed: (transaction) => _onTransactionPressed(ctx, transaction),
              ),
            ),
            ExpandedRaisedTextButton(
              text: "Transfer",
              onPressed: () => pushRoute(Navigator.of(ctx), () => SelectTransferDestinationRoute()),
            )
          ],
        ),
      );

  _onTransactionPressed(BuildContext ctx, Transaction transaction) =>
      showDialog(context: ctx, builder: (ctx) => prepareAlertDialog(ctx, transaction));

  AlertDialog prepareAlertDialog(BuildContext ctx, Transaction transaction) =>
      AlertDialog(title: Center(child: Text("Transaction detail")), content: TransactionDetailsWidget(transaction));
}
