import 'package:ercoin_wallet/interactor/account_info/account_info_interctor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:ercoin_wallet/utils/view/address_qr_code.dart';
import 'package:ercoin_wallet/utils/view/image_dialog.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/transfer_list.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/transfer/destination/select_transfer_destination_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class AccountInfoPage extends StatelessWidget {
  final _interactor = mainInjector.getDependency<AccountInfoInteractor>();

  AccountInfoPage();

  @override
  Widget build(BuildContext ctx) => Container(
        padding: standardPadding.copyWith(bottom: 0),
        child: FutureBuilderWithProgress(
          future: _interactor.obtainActiveLocalAccountDetails(),
          builder: (LocalAccountDetails details) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(children: <Widget>[
                Expanded(child: _accountInfoSection(ctx, details)),
                AddressQrCode(address: details.localAccount.namedAddress.address),
              ]),
              if(details.isRegistered) ...[
                Expanded(child: _transferList(ctx)),
                _transferBtn(ctx)
              ] else
                Expanded(
                    child: Center(child: const Text("Nothing to show"))
                ),
            ],
          ),
        ),
      );

  Widget _accountInfoSection(BuildContext ctx, LocalAccountDetails localAccountDetails) => Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _accountNameRow(localAccountDetails),
            _accountBalanceRow(localAccountDetails),
            _accountAddressRow(ctx, localAccountDetails),
            if (!localAccountDetails.isRegistered) _accountNotRegisteredRow(),
          ],
        ),
      );

  Widget _accountNameRow(LocalAccountDetails localAccountDetails) => Row(children: <Widget>[
        const Icon(Icons.account_circle),
        const SizedBox(width: 8.0),
        Expanded(
            child: Text(
                localAccountDetails.localAccount.namedAddress.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis
            ),
        ),
      ]);

  Widget _accountNotRegisteredRow() => Row(children: <Widget>[
        const Icon(Icons.warning, color: Colors.red),
        const SizedBox(width: 8.0),
        const Text("Not registered", style: const TextStyle(color: Colors.red)),
      ]);

  Widget _accountAddressRow(BuildContext ctx, LocalAccountDetails localAccountDetails) => Row(
        children: <Widget>[
          Text(localAccountDetails.localAccount.namedAddress.address.base58.substring(0, 15) + "..."),
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
        ],
      );

  Widget _accountBalanceRow(LocalAccountDetails localAccountDetails) => Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text(localAccountDetails.balance.ercoinFixed,
              style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
          const SizedBox(width: 3.0),
          const Text("ERN", style: const TextStyle(fontWeight: FontWeight.w300)),
        ],
      );

  Widget _transferList(BuildContext ctx) => FutureBuilderWithProgress(
        future: _interactor.obtainRecentTransfers(),
        builder: (transfers) => TransferList(list: transfers),
      );

  Widget _transferBtn(BuildContext ctx) => RaisedButton.icon(
        icon: const Text("Transfer"),
        label: const Icon(Icons.send),
        onPressed: () => pushRoute(Navigator.of(ctx), () => SelectTransferDestinationRoute()),
      );

  _onCopyPressed(BuildContext ctx, LocalAccountDetails localAccountDetails) {
    Clipboard.setData(new ClipboardData(text: localAccountDetails.localAccount.namedAddress.address.base58));

    showTextSnackBar(Scaffold.of(ctx), "Address copied to clipboard");
  }
}
