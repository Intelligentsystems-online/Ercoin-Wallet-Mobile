import 'package:ercoin_wallet/repository/addressBook/AddressBookEntry.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressBookEntryList extends StatelessWidget {
  final List<AddressBookEntry> addresseBookEntries;
  final Function(BuildContext, AddressBookEntry) onAddressPressed;

  const AddressBookEntryList({this.addresseBookEntries, this.onAddressPressed});

  @override
  Widget build(BuildContext ctx) => ListView.builder(
      itemCount: addresseBookEntries.length,
      itemBuilder: (context, index) => ExpandedRow(child: _addressRow(ctx, addresseBookEntries[index]))
  );

  Widget _addressRow(BuildContext ctx, AddressBookEntry address) => GestureDetector(
    onTap: () => onAddressPressed(ctx, address),
    child: Card(
      child: ListTile(
        leading: Icon(Icons.person, color: Colors.blue),
        title: Text(address.name)
      ),
    )
  );
}
