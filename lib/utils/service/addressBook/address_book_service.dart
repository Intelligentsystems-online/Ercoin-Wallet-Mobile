import 'dart:async';

import 'package:ercoin_wallet/repository/addressBook/AddressBookEntry.dart';
import 'package:ercoin_wallet/repository/addressBook/AddressBookRepository.dart';

class AddressBookService {
  final AddressBookRepository _addressBookRepository;

  AddressBookService(this._addressBookRepository);

  Future<List<AddressBookEntry>> obtainAddressBookEntries() => _addressBookRepository.findAll();

  Future<AddressBookEntry> addAddressBookEntry(String publicKey, String accountName) => _addressBookRepository.createAddressBookEntry(publicKey, accountName);

  Future<List<AddressBookEntry>> obtainAddressBookEntriesByName(String name) async {
    final entries = await _addressBookRepository.findAll();

    return entries
        .where((entry) => _contains(name, entry))
        .toList();
  }

  _contains(String value, AddressBookEntry entry) => entry
      .name
      .toLowerCase()
      .contains(value.toLowerCase());
}