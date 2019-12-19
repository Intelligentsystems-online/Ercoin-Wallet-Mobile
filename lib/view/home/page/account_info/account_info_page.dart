import 'package:ercoin_wallet/interactor/account_info/account_info_interctor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:ercoin_wallet/utils/view/image_dialog.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/transfer_details_widget.dart';
import 'package:ercoin_wallet/utils/view/transfer_list.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:ercoin_wallet/view/transfer/select_destination/select_transfer_destination_route.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AccountInfoPage extends StatelessWidget {
  final _interactor = mainInjector.getDependency<AccountInfoInteractor>();

  final _transactionListPageIndex = 1;

  @override
  Widget build(BuildContext ctx) => FutureBuilderWithProgress(
        future: _interactor.obtainActiveLocalAccountDetails(),//.obtainActiveAccountWithBalance(),
        builder: (localAccountDetails) => Container(
          padding: standardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(children: <Widget>[
                Expanded(child: _accountInfoSection(ctx, localAccountDetails)),
                _qrCodeSection(ctx, localAccountDetails),
              ]),
              Expanded(child: _transferList(ctx)),
              _transferBtn(ctx),
            ],
          ),
        ),
      );

  Widget _accountInfoSection(BuildContext ctx, LocalAccountDetails localAccountDetails) => Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _accountNameRow(localAccountDetails),
            _accountAddressRow(ctx, localAccountDetails),
            _accountBalanceRow(localAccountDetails),
          ],
        ),
      );

  Widget _accountNameRow(LocalAccountDetails localAccountDetails) => Row(children: <Widget>[
        const Icon(Icons.account_circle),
        const SizedBox(width: 8.0),
        Text(localAccountDetails.localAccount.namedAddress.name, style: const TextStyle(fontWeight: FontWeight.bold))
      ]);

  Widget _accountAddressRow(BuildContext ctx, LocalAccountDetails localAccountDetails) => Row(children: <Widget>[
        Text(localAccountDetails.localAccount.namedAddress.address.publicKey.substring(0, 15) + "...", maxLines: 1),
        SizedBox(
          width: 25.0,
          height: 25.0,
          child: IconButton(
            icon: const Icon(Icons.content_copy),
            iconSize: 15.0,
            padding: EdgeInsets.zero,
            onPressed: () => _onCopyPressed(ctx, localAccountDetails),
          ),
        ),
      ]);

  Widget _accountBalanceRow(LocalAccountDetails localAccountDetails) => Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text(localAccountDetails.balance.microErcoin.toString(), style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
          const SizedBox(width: 3.0),
          const Text("mERN"),
        ],
      );

  Widget _qrCodeSection(BuildContext ctx, LocalAccountDetails localAccountDetails) => GestureDetector(
    onTap: () => _onQrCodePressed(ctx, localAccountDetails),
    child: _qrCodeImage(localAccountDetails, 150)
  );

  _onQrCodePressed(BuildContext ctx, LocalAccountDetails localAccountDetails) =>
      showDialog(context: ctx, builder: (ctx) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: ImageDialog(_qrCodeImage(localAccountDetails, 230)),
      ));

  Widget _qrCodeImage(LocalAccountDetails localAccountDetails, double imageSize) => QrImage(
    data: localAccountDetails.localAccount.namedAddress.address.publicKey,
    size: imageSize,
    padding: standardPadding,
    backgroundColor: Colors.white,
  );

  Widget _transferList(BuildContext ctx) => FutureBuilderWithProgress(
        future: _interactor.obtainRecentTransfers(),
        builder: (transfers) => Stack(children: <Widget>[
          Positioned.fill(
              child: TransferList(
                transferList: transfers,
                onTransactionPressed: (transfer) => _onTransactionPressed(ctx, transfer),
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
        onPressed: () => pushRoute(Navigator.of(ctx), () => HomeRoute(initialPageIndex: _transactionListPageIndex)),
      );

  Widget _transferBtn(BuildContext ctx) => RaisedButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[const Text("Transfer"), const SizedBox(width: 8.0), const Icon(Icons.send)],
        ),
        onPressed: () => pushRoute(Navigator.of(ctx), () => SelectTransferDestinationRoute()),
      );

  _onCopyPressed(BuildContext ctx, LocalAccountDetails localAccountDetails) {
    Clipboard.setData(new ClipboardData(text: localAccountDetails.localAccount.namedAddress.address.publicKey));

    Scaffold.of(ctx).showSnackBar(SnackBar(
        content: const Text("Address copied to clipboard"),
    ));
  }

  _onTransactionPressed(BuildContext ctx, Transfer transfer) =>
      showDialog(context: ctx, builder: (ctx) => prepareAlertDialog(ctx, transfer));

  AlertDialog prepareAlertDialog(BuildContext ctx, Transfer transfer) =>
      AlertDialog(title: Center(child: Text("Transaction detail")), content: TransferDetailsWidget(transfer));
}
