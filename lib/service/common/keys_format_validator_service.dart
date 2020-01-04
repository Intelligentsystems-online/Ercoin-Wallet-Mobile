import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/private_key.dart';

class KeysFormatValidatorService {
  validatePublicKey(String key) {
    if(key.isEmpty)
      return "Enter address value";
    else try {
      Address.ofBase58(key);
    } on FormatException catch(exception) {
      return exception.message;
    }
  }

  validatePrivateKey(String key)  {
    if(key.isEmpty)
      return "Enter private key value";
    else try {
      PrivateKey.ofBase58(key);
    } on FormatException catch(exception) {
      return exception.message;
    }
  }
}
