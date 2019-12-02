import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressDetailsWidget extends StatelessWidget {
  final Address address;

  const AddressDetailsWidget(this.address);

  @override
  Widget build(BuildContext ctx) => Column(
    children: <Widget>[
      Text("Name: ${address.accountName}"),
      Text("Address: ${address.publicKey}"),
      _closeBtn(ctx)
    ]
  );

  Widget _closeBtn(BuildContext ctx) => ExpandedRaisedTextButton(
    text: "Close",
    onPressed: () => Navigator.of(ctx).pop(),
  );
}
