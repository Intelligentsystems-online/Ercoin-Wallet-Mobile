import 'dart:async';

import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/repository/address/AddressRepository.dart';

//TODO(DI)
class SelectTransferDestinationInteractor {
  final _addressRepository = AddressRepository();

  Future<List<Address>> obtainAddressList() => _addressRepository.findAll();

  Future<Address> addAddress(String address, String name) async {
    final addressEntry = Address(address, address, name);
    
    _addressRepository.createAddress(addressEntry);

    return addressEntry;
  }
}
