import 'package:ercoin_wallet/utils/service/addressBook/address_book_service.dart';

class EnterAddressEntryInteractor {
  final AddressBookService _addressBookService;

  EnterAddressEntryInteractor(this._addressBookService);

  Future<List<String>> obtainAddresses() => _addressBookService
      .obtainAddressBookEntries()
      .then((entries) => entries.map((entry) => entry.publicKey).toList());
}