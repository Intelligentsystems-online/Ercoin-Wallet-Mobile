import 'package:ercoin_wallet/repository/addressBook/AddressBookEntry.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressBookEntryDetailsWidget extends StatelessWidget {
  final AddressBookEntry addressBookEntry;

  const AddressBookEntryDetailsWidget(this.addressBookEntry);

  @override
  Widget build(BuildContext ctx) => Column(
    children: <Widget>[
      Text("Name: ${addressBookEntry.name}"),
      Text("Address: ${addressBookEntry.publicKey}"),
      _closeBtn(ctx)
    ]
  );

  Widget _closeBtn(BuildContext ctx) => ExpandedRaisedTextButton(
    text: "Close",
    onPressed: () => Navigator.of(ctx).pop(),
  );
}
