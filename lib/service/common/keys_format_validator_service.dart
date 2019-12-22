import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/addresses.dart';
import 'package:ercoin_wallet/model/base/private_key.dart';
import 'package:ercoin_wallet/model/base/private_keys.dart';

class KeysFormatValidatorService {
  validatePublicKey(Address address) {
    if(address.publicKey.isEmpty)
      return "Enter address value";
    else try {
      final addressBytes = Addresses.toBytes(address);

      return addressBytes.length == Address.requiredBytesLength ? null : "Invalid address length";
    } on FormatException {
      return "Invalid address format";
    }
  }

  validatePrivateKey(PrivateKey privateKey)  {
    if(privateKey.privateKey.isEmpty)
      return "Enter private key value";
    else try {
      final privateKeyBytes = PrivateKeys.toBytes(privateKey);

      return privateKeyBytes.length == PrivateKey.requiredBytesLength ? null : "Invalid private key length";
    } on FormatException {
      return "Invalid private key format";
    }
  }
}
