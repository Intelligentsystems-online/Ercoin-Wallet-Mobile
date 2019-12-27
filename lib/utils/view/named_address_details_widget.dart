import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NamedAddressDetailsWidget extends StatelessWidget {
  final NamedAddress namedAddress;

  const NamedAddressDetailsWidget(this.namedAddress);

  @override
  Widget build(BuildContext ctx) => Column(
    children: <Widget>[
      Text("Name: ${namedAddress.name}"),
      Text("Address: ${namedAddress.address.base58}"),
      _closeBtn(ctx)
    ]
  );

  Widget _closeBtn(BuildContext ctx) => ExpandedRaisedTextButton(
    text: "Close",
    onPressed: () => Navigator.of(ctx).pop(),
  );
}
