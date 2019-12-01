import 'dart:async';

import 'package:ercoin_wallet/repository/address/Address.dart';

//TODO(Interactor)
class AddAddressInteractor {
  Future<Address> saveAddress(String publicKey, String addressName) async {
    return Address("id", publicKey, addressName);
  }
}