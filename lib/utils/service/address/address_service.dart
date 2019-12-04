import 'dart:async';

import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/repository/address/AddressRepository.dart';

class AddressService {
  final _addressRepository = AddressRepository();

  Future<List<Address>> obtainAddresses() => _addressRepository.findAll();

  Future<int> saveAddress(Address address) => _addressRepository.createAddress(address);
}