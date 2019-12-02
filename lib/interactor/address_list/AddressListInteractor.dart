import 'dart:async';

import 'package:ercoin_wallet/repository/address/Address.dart';

//TODO(Interactor)
class AddressListInteractor {
  Future<List<Address>> obtainAddresses() async {
    final addressList = [Address("1", "pk_1", "name_1"), Address("2", "pk_2", "name_2")];

    return addressList;
  }
}