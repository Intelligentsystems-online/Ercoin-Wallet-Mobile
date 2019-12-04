import 'dart:async';

import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/repository/address/AddressRepository.dart';
import 'package:ercoin_wallet/utils/service/address/address_service.dart';

//TODO(DI)
class SelectTransferDestinationInteractor {
  final _addressService = AddressService();

  Future<List<Address>> obtainAddressList() => _addressService.obtainAddresses();

  Future<Address> addAddress(String address, String name) async {
    final addressEntry = Address(address, address, name);
    
    await _addressService.saveAddress(addressEntry);

    return addressEntry;
  }
}
