import 'dart:async';

import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/utils/service/address/address_service.dart';

class AddressListInteractor {
  final AddressService _addressService;

  AddressListInteractor(this._addressService);

  Future<List<Address>> obtainAddresses() => _addressService.obtainAddresses();

  Future<Address> addAddress(String address, String name) => _addressService.saveAddress(address, name);
}