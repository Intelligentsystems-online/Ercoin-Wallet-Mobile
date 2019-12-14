import 'package:ercoin_wallet/repository/addressBook/AddressBookEntry.dart';
import 'package:ercoin_wallet/utils/view/address_book_entry_list.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchableAddressBookEntryList extends StatelessWidget {
  final List<AddressBookEntry> addresseBookEntries;
  final Function(BuildContext, AddressBookEntry) onAddressPressed;
  final Function(String) onSearchChanged;

  const SearchableAddressBookEntryList({this.addresseBookEntries, this.onAddressPressed, this.onSearchChanged});

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: TextField(
          onChanged: (value) => onSearchChanged(value),
          decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: standardTextFieldBorder),
        )
      ),
      Flexible(
        child: AddressBookEntryList(addresseBookEntries: addresseBookEntries, onAddressPressed: onAddressPressed)
      )
    ],
  );
}