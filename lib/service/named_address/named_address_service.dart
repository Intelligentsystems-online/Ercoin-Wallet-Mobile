import 'dart:async';

import 'package:ercoin_wallet/model/address.dart';
import 'package:ercoin_wallet/model/named_address.dart';
import 'package:ercoin_wallet/repository/named_address/named_address_repository.dart';

class NamedAddressService {
  final NamedAddressRepository _repository;

  const NamedAddressService(this._repository);

  Future<List<NamedAddress>> obtainList() async => await _repository.findAll();

  Future<NamedAddress> create(Address address, String name) async =>
      await _repository.create(address, name);

  Future<List<NamedAddress>> obtainListByNameContains(String name) async =>
      await _repository.findByNameContains(name);
}
