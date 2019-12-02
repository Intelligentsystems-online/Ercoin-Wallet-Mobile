import 'package:ercoin_wallet/repository/address/Address.dart';
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

  FlatButton _closeBtn(BuildContext ctx) => FlatButton(
    child: Text("Close", style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
    onPressed: () => Navigator.of(ctx).pop(),
  );
}
