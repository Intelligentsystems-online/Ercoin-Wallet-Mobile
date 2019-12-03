import 'dart:async';

import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/repository/address/AddressRepository.dart';

//TODO(DI)
class AddressListInteractor {
  final _addressRepository = AddressRepository();

  Future<List<Address>> obtainAddresses() => _addressRepository.findAll();
}