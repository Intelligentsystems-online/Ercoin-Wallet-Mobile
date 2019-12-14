import 'dart:async';

import 'package:ercoin_wallet/repository/addressBook/AddressBookEntry.dart';
import 'package:ercoin_wallet/repository/addressBook/AddressBookRepository.dart';

class AddressBookService {
  final AddressBookRepository _addressBookRepository;

  AddressBookService(this._addressBookRepository);

  Future<List<AddressBookEntry>> obtainAddressBookEntries() => _addressBookRepository.findAll();

  Future<AddressBookEntry> addAddressBookEntry(String publicKey, String accountName) => _addressBookRepository.createAddressBookEntry(publicKey, accountName);

  List<AddressBookEntry> filterAddressBookEntriesBy(String value, List<AddressBookEntry> entries) => entries
      .where((entry) => _contains(value, entry))
      .toList();

  _contains(String value, AddressBookEntry entry) => entry
      .accountName
      .toLowerCase()
      .contains(value.toLowerCase());
}