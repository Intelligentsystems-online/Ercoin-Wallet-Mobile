import 'dart:async';

import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/repository/address/AddressRepository.dart';
import 'package:ercoin_wallet/utils/service/address/address_service.dart';

//TODO(DI)
class AddressListInteractor {
  final _addressService = AddressService();

  Future<List<Address>> obtainAddresses() => _addressService.obtainAddresses();
}