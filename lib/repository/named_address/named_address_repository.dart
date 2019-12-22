import 'dart:async';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/repository/named_address/named_address_db.dart';


class NamedAddressRepository
{
  final NamedAddressDb _db;

  NamedAddressRepository(this._db);

  Future<NamedAddress> create(Address address, String name) async {
    final namedAddress = NamedAddress(address: address, name: name);
    await _db.insert(_serialize(namedAddress));
    return namedAddress;
  }

  Future<List<NamedAddress>> findAll() async =>
      _deserializeList(await _db.queryAll());

  Future<List<NamedAddress>> findByNameContains(String value) async =>
    _deserializeList(await _db.queryByNameContains(value));

  Future<NamedAddress> findByAddressOrNull(Address address) async =>
    _deserializeOneOrNull(await _db.queryByPublicKey(hex.encode(address.bytes)));

  List<NamedAddress> _deserializeList(List<Map<String, dynamic>> response) => response.map(_deserialize).toList();
  
  NamedAddress _deserializeOneOrNull(List<Map<String, dynamic>> response) => 
      response.isNotEmpty ? _deserialize(response.first) : null;

  static Map<String, dynamic> _serialize(NamedAddress data) => {
    NamedAddressDb.publicKeyRow: hex.encode(data.address.bytes),
    NamedAddressDb.nameRow: data.name,
  };

  static NamedAddress _deserialize(Map<String, dynamic> data) => NamedAddress(
    address: Address(bytes: hex.decode(data[NamedAddressDb.publicKeyRow])),
    name: data[NamedAddressDb.nameRow],
  );
}
