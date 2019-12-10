import 'dart:async';

import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/repository/address/AddressRepository.dart';

class AddressService {
  final AddressRepository addressRepository;

  AddressService({this.addressRepository});

  Future<List<Address>> obtainAddresses() => addressRepository.findAll();

  Future<Address> saveAddress(String publicKey, String accountName) => addressRepository.createAddress(publicKey, accountName);
}