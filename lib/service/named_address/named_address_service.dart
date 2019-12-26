import 'dart:async';

import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/repository/named_address/named_address_repository.dart';

class NamedAddressService {
  final NamedAddressRepository _repository;

  const NamedAddressService(this._repository);

  Future<List<NamedAddress>> obtainList() async => await _repository.findAll();

  Future<NamedAddress> create(Address address, String name) async =>
      await _repository.create(address, name);

  Future<List<NamedAddress>> obtainListByNameContains(String name) async =>
      await _repository.findByNameContains(name);

  Future<NamedAddress> obtainByAddressOrNull(Address address) async =>
      await _repository.findByAddressOrNull(address);

  Future<bool> exists(Address address) async =>
      await _repository.findByAddressOrNull(address) == null ? false : true;
}
