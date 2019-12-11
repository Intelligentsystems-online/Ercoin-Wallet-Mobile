import 'package:ercoin_wallet/interactor/account_info/account_info_interctor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/model/account_info.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/transaction_details_widget.dart';
import 'package:ercoin_wallet/utils/view/transaction_list.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/transfer/select_destination/select_transfer_destination_route.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AccountInfoPage extends StatelessWidget {
  final _interactor = mainInjector.getDependency<AccountInfoInteractor>();

  @override
  Widget build(BuildContext ctx) => FutureBuilderWithProgress(
        future: _interactor.obtainActiveAccountWithBalance(),
        builder: (info) => Container(
          padding: standardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(children: <Widget>[
                Expanded(child: _accountInfoSection(ctx, info)),
                _qrCodeSection(ctx, info),
              ]),
              Expanded(child: _transactionList(ctx)),
              _transferBtn(ctx),
            ],
          ),
        ),
      );

  Widget _accountInfoSection(BuildContext ctx, AccountInfo info) => Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _accountNameRow(info),
            _accountAddressRow(info),
            _accountBalanceRow(info),
          ],
        ),
      );

  Widget _accountNameRow(AccountInfo info) => Row(children: <Widget>[
        const Icon(Icons.account_circle),
        const SizedBox(width: 8.0),
        Text(info.account.accountName, style: const TextStyle(fontWeight: FontWeight.bold))
      ]);

  Widget _accountAddressRow(AccountInfo info) => Row(children: <Widget>[
        Text(info.account.publicKey.substring(0, 15) + "...", maxLines: 1),
        SizedBox(
          width: 25.0,
          height: 25.0,
          child: IconButton(
            icon: const Icon(Icons.content_copy),
            iconSize: 15.0,
            padding: EdgeInsets.zero,
            onPressed: () => null,
          ),
        ),
      ]);

  Widget _accountBalanceRow(AccountInfo info) => Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text(info.balanceMicro.toString(), style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
          const SizedBox(width: 3.0),
          const Text("mEC"),
        ],
      );

  Widget _qrCodeSection(BuildContext ctx, AccountInfo info) => QrImage(
    data: info.account.publicKey,
    size: 150,
    padding: standardPadding,
    backgroundColor: Colors.white,
  );

  Widget _transactionList(BuildContext ctx) => FutureBuilderWithProgress(
        future: _interactor.obtainRecentTransactions(),
        builder: (transactions) => Stack(children: <Widget>[
          Positioned.fill(
              child: TransactionList(
            transactions: transactions,
            onTransactionPressed: (transaction) => _onTransactionPressed(ctx, transaction),
          )),
          Align(
            alignment: Alignment.bottomRight,
            child: _showHistoryBtn(ctx),
          ),
        ]),
      );

  Widget _showHistoryBtn(BuildContext ctx) => RaisedButton(
        color: Theme.of(ctx).cardColor,
        textColor: Theme.of(ctx).primaryColor,
        child: Row(
          children: <Widget>[const Text("Show full history"), const Icon(Icons.arrow_forward)],
          mainAxisSize: MainAxisSize.min,
        ),
        onPressed: () => null,
      );

  Widget _transferBtn(BuildContext ctx) => RaisedButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[const Text("Transfer"), const SizedBox(width: 8.0), const Icon(Icons.send)],
        ),
        onPressed: () => pushRoute(Navigator.of(ctx), () => SelectTransferDestinationRoute()),
      );

  _onTransactionPressed(BuildContext ctx, Transaction transaction) =>
      showDialog(context: ctx, builder: (ctx) => prepareAlertDialog(ctx, transaction));

  AlertDialog prepareAlertDialog(BuildContext ctx, Transaction transaction) =>
      AlertDialog(title: Center(child: Text("Transaction detail")), content: TransactionDetailsWidget(transaction));
}
