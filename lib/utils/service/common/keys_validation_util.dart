class KeysValidationUtil {
  static final publicKeyType = "public key";
  static final privateKeyType = "private key";

  final _regExp = RegExp("^[0-9a-f]+\$", caseSensitive: false);

  validatePublicKey(String publicKey, List<String> keysInUse) {
    final validationResult = _validateKey(publicKey, publicKey, 64);

    return validationResult == null ? _validateKeyInList(keysInUse, publicKey) : validationResult;
  }

  validatePrivateKey(String privateKey) => _validateKey(privateKey, privateKeyType, 128);

  _validateKey(String key, String keyType, int length) {
    if(key.isEmpty)
      return "Enter $keyType";
    if(key.length != length)
      return "Incorrect $keyType length";
    if(!_isHexadecimal(key))
      return "Incorrect $keyType value";
    else return null;
  }

  _validateKeyInList(List<String> keys, String key) => keys.contains(key) ? "Public key is already used" : null;

  bool _isHexadecimal(String text) => _regExp.hasMatch(text);
}