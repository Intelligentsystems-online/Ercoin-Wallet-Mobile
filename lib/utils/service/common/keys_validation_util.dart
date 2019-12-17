class KeysValidationUtil {
  static final _publicKeyType = "public key";
  static final _privateKeyType = "private key";
  static final _publicKeyLength = 64;
  static final _privateKeyLength = 128;

  final _regExp = RegExp("^[0-9a-f]+\$", caseSensitive: false);

  validatePublicKey(String publicKey) => _validateKey(publicKey, _publicKeyType, _publicKeyLength);

  validatePrivateKey(String privateKey) => _validateKey(privateKey, _privateKeyType, _privateKeyLength);

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