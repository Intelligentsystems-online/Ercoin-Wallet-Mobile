// TODO(Interactor)
import 'dart:async';

import 'package:ercoin_wallet/repository/address/Address.dart';

class SelectTransferDestinationInteractor {
  Future<List<Address>> obtainAddressList() async {
    return [Address("id", "pk", "accountName")];
  }

  Future<Address> addAddress(String address, String name) async {
    return Address(address, address, name);
  }
}
