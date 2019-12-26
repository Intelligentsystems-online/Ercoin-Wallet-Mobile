import 'dart:async';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/model/base/private_key.dart';
import 'package:ercoin_wallet/repository/local_account/local_account_db.dart';


class LocalAccountRepository {
  final LocalAccountDb _db;

  const LocalAccountRepository(this._db);

  Future<LocalAccount> create(Address address, String name, PrivateKey privateKey) async {
    final localAccount = LocalAccount(
        namedAddress: NamedAddress(address: address, name: name), 
        privateKey: privateKey
    );
    await _db.insert(_serialize(localAccount));
    return localAccount;
  }

  Future<List<LocalAccount>> findAll() async =>
      _deserializeList(await _db.queryAll());

  Future<LocalAccount> findByAddressOrNull(Address address) async =>
      _deserializeOneOrNull(await _db.queryByPublicKey(hex.encode(address.bytes)));

  Future<List<LocalAccount>> findByNameContains(String value) async =>
      _deserializeList(await _db.queryByNameContains(value));

  List<LocalAccount> _deserializeList(List<Map<String, dynamic>> response) =>
      response.map(_deserialize).toList();

  LocalAccount _deserializeOneOrNull(List<Map<String, dynamic>> response) =>
      response.isNotEmpty ? _deserialize(response.first) : null;

  Map<String, dynamic> _serialize(LocalAccount data) => {
    LocalAccountDb.publicKeyRow: hex.encode(data.namedAddress.address.bytes),
    LocalAccountDb.privateKeyRow: hex.encode(data.privateKey.bytes),
    LocalAccountDb.nameRow: data.namedAddress.name,
  };

  LocalAccount _deserialize(Map<String, dynamic> data) => LocalAccount(
    namedAddress: NamedAddress(
      address: Address(bytes: hex.decode(data[LocalAccountDb.publicKeyRow])),
      name: data[LocalAccountDb.nameRow],
    ),
    privateKey: PrivateKey(bytes: hex.decode(data[LocalAccountDb.privateKeyRow])),
  );
}
