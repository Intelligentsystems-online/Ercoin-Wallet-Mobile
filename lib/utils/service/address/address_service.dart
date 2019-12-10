import 'dart:async';

import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/repository/address/AddressRepository.dart';

class AddressService {
  final AddressRepository _addressRepository;

  AddressService(this._addressRepository);

  Future<List<Address>> obtainAddresses() => _addressRepository.findAll();

  Future<Address> saveAddress(String publicKey, String accountName) => _addressRepository.createAddress(publicKey, accountName);
}