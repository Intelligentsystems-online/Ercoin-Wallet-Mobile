import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:ercoin_wallet/model/transfer/utils/transfers.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/standard_copy_text_box.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/view/add_address/add_address_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

class TransferDetailsRoute extends StatelessWidget {
  final Transfer transfer;

  const TransferDetailsRoute({this.transfer});

  @override
  Widget build(BuildContext ctx) => Scaffold(
        appBar: AppBar(title: const Text("Transfer details")),
        body: TopAndBottomContainer(
          top: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 32.0),
              _amountCaption(),
              _amountText(),
              const SizedBox(height: 40.0),
              _foreignAddressBox(),
              const SizedBox(height: 16.0),
              _messageBox(),
              const SizedBox(height: 16.0),
              _timestampBox(),
            ],
          ),
          bottom: _foreignAddressBtn(ctx),
        ),
      );

  Widget _amountCaption() => const Text(
    "Amount",
    textAlign: TextAlign.center,
    style: const TextStyle(fontWeight: FontWeight.w300),
  );

  Widget _amountText() => Text(
    Transfers.deltaAmountMicroErcoinSigned(transfer),
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      color: Transfers.byDirection(transfer, onIn: Colors.green, onOut: Colors.black),
    ),
  );

  Widget _foreignAddressBox() => StandardCopyTextBox(
    value: Transfers.foreignAddressNameOrPublicKey(transfer),
    clipboardValue: Transfers.foreignAddress(transfer).base58,
    labelText: Transfers.byDirection(transfer, onIn: "From", onOut: "To"),
    onCopiedText: "Address copied to clipboard",
  );

  Widget _messageBox() => StandardCopyTextBox(
    value: transfer.data.message,
    labelText: "Message",
  );

  Widget _timestampBox() => StandardCopyTextBox(
        value: transfer.data.timestamp.toIso8601String(),
        labelText: "Timestamp",
      );

  Widget _foreignAddressBtn(BuildContext ctx) => ExpandedRaisedTextButton(
    text: transfer.foreignAddressNamed == null ? "Add to address book" : "View address details",
    onPressed: () {
      if (transfer.foreignAddressNamed == null) {
        pushRoute(
          Navigator.of(ctx),
          () => AddAddressRoute(initialAddress: Transfers.foreignAddress(transfer)),
        );
      } else {
        // TODO(Address details)
      }
    },
  );
}
