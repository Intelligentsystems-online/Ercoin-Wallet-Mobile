import 'package:ercoin_wallet/model/base/addresses.dart';
import 'package:ercoin_wallet/model/base/private_keys.dart';

class KeysFormatValidatorService {
  validatePublicKey(String publicKey) {
    if(publicKey.isEmpty)
      return "Enter address value";
    else try {
      Addresses.fromString(publicKey);
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
