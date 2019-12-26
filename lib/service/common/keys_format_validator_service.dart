import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/private_keys.dart';

class KeysFormatValidatorService {
  validatePublicKey(String publicKey) {
    if(publicKey.isEmpty)
      return "Enter address value";
    else try {
      Address.ofBase58(publicKey);
    } on FormatException {
      return "Invalid address format";
    }

  }

  validatePrivateKey(String privateKey)  {
    if(privateKey.isEmpty)
      return "Enter private key value";
    else try {
      PrivateKeys.fromString(privateKey);
    } on FormatException {
      return "Invalid private key format";
    }
  }
}
