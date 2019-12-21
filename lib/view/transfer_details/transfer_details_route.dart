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
              const Text(
                "Amount",
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w300),
              ),
              Text(
                Transfers.deltaAmountMicroErcoinSigned(transfer),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Transfers.byDirection(transfer, onIn: Colors.green, onOut: Colors.black),
                ),
              ),
              const SizedBox(height: 40.0),
              StandardCopyTextBox(
                value: Transfers.foreignAddressNameOrPublicKey(transfer),
                clipboardValue: Transfers.foreignAddress(transfer).publicKey,
                labelText: Transfers.byDirection(transfer, onIn: "From", onOut: "To"),
                onCopiedText: "Address copied to clipboard",
              ),
              const SizedBox(height: 16.0),
              StandardCopyTextBox(
                value: transfer.data.message,
                labelText: "Message",
              )
            ],
          ),
          bottom: ExpandedRaisedTextButton(
            text: transfer.foreignAddressNamed == null ? "Add to address book" : "View address details",
            onPressed: () {
              if(transfer.foreignAddressNamed == null) {
                pushRoute(
                    Navigator.of(ctx),
                        () => AddAddressRoute(initialAddress: Transfers.foreignAddress(transfer)),
                );
              } else {
                // TODO(Address details)
              }
            },
          ),
        ),
      );
}
