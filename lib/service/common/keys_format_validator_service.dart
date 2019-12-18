import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/private_key.dart';

class KeysFormatValidatorService {
  static final _publicKeyType = "public key";
  static final _privateKeyType = "private key";

  final _regExp = RegExp("^[0-9a-f]+\$", caseSensitive: false);

  validatePublicKey(String publicKey) => _validateKey(publicKey, _publicKeyType, Address.requiredPublicKeyLength);

  validatePrivateKey(String privateKey) => _validateKey(privateKey, _privateKeyType, PrivateKey.requiredLength);

  _validateKey(String key, String keyType, int length) {
    if(key.isEmpty)
      return "Enter $keyType";
    if(key.length != length)
      return "Incorrect $keyType length";
    if(!_isHexadecimal(key))
      return "Incorrect $keyType value";
    else return null;
  }

  bool _isHexadecimal(String text) => _regExp.hasMatch(text);
}
