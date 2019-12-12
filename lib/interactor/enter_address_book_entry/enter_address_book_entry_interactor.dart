import 'package:ercoin_wallet/repository/addressBook/AddressBookEntry.dart';
import 'package:ercoin_wallet/utils/service/addressBook/address_book_service.dart';

class EnterAddressBookEntryInteractor {
  final AddressBookService _addressBookService;

  EnterAddressBookEntryInteractor(this._addressBookService);

  Future<List<String>> obtainAddressBookKeys() => _addressBookService
      .obtainAddressBookEntries()
      .then((entries) => _obtainPublicKeys(entries));

  List<String> _obtainPublicKeys(List<AddressBookEntry> entries) => entries
      .map((entry) => entry.publicKey)
      .toList();
}