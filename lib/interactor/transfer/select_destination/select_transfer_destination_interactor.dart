import 'dart:async';

import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/utils/service/address/address_service.dart';

//TODO(DI)
class SelectTransferDestinationInteractor {
  final AddressService addressService;

  SelectTransferDestinationInteractor({this.addressService});

  Future<List<Address>> obtainAddressList() => addressService.obtainAddresses();

  Future<Address> addAddress(String address, String name) => addressService.saveAddress(address, name);
}
