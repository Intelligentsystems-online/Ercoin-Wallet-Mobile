import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressDetailWidget extends StatelessWidget {
  final Address address;

  const AddressDetailWidget(this.address);

  @override
  Widget build(BuildContext ctx) => Column(
    children: <Widget>[
      Text("Name: " + address.accountName),
      Text("Address: " + address.publicKey),
      _closeBtn(ctx)
    ]
  );

  FlatButton _closeBtn(BuildContext ctx) => FlatButton(
    child: Text("Close", style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
    onPressed: () => Navigator.of(ctx).pop(),
  );
}
