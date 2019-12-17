import 'dart:async';

import 'package:ercoin_wallet/repository/addressBook/AddressBookEntry.dart';
import 'package:ercoin_wallet/utils/service/addressBook/address_book_service.dart';

class SelectTransferDestinationInteractor {
  final AddressBookService _addressBookService;

  SelectTransferDestinationInteractor(this._addressBookService);

  Future<List<AddressBookEntry>> obtainAddressBookEntries() => _addressBookService.obtainAddressBookEntries();

  Future<AddressBookEntry> addAddressBookEntry(String address, String name) => _addressBookService.addAddressBookEntry(address, name);

  Future<List<AddressBookEntry>> obtainAddressBookEntriesByName(String name) => _addressBookService.obtainAddressBookEntriesByName(name);
}
