import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/private_key.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

@immutable
class LocalAccountKeys {
  final Address address;
  final PrivateKey privateKey;

  const LocalAccountKeys({@required this.address, @required this.privateKey});
  static ofKeyPair(KeyPair keyPair) => LocalAccountKeys(
    address: Address.ofBytes(keyPair.publicKey),
    privateKey: PrivateKey.ofBytes(keyPair.secretKey)
  );
}
