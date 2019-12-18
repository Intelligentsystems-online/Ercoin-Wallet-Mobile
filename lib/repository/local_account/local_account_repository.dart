import 'dart:async';

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

  Future<LocalAccount> findByAddress(Address address) async =>
      _deserializeExactlyOne(await _db.queryByPublicKey(address.publicKey));

  Future<List<LocalAccount>> findByNameContains(String value) async =>
      _deserializeList(await _db.queryByNameContains(value));

  List<LocalAccount> _deserializeList(List<Map<String, dynamic>> response) =>
      response.map(_deserialize).toList();

  LocalAccount _deserializeExactlyOne(List<Map<String, dynamic>> response) =>
      response.length == 1 ? _deserialize(response.first) : throw Exception("Account not found");

  Map<String, dynamic> _serialize(LocalAccount data) => {
    LocalAccountDb.publicKeyRow: data.namedAddress.address.publicKey,
    LocalAccountDb.privateKeyRow: data.privateKey.privateKey,
    LocalAccountDb.nameRow: data.namedAddress,
  };

  LocalAccount _deserialize(Map<String, dynamic> data) => LocalAccount(
    namedAddress: NamedAddress(
      address: Address(publicKey: data[LocalAccountDb.publicKeyRow]),
      name: data[LocalAccountDb.nameRow],
    ),
    privateKey: PrivateKey(privateKey: data[LocalAccountDb.privateKeyRow]),
  );
}
