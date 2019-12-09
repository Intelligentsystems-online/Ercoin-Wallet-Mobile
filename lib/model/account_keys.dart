class AccountKeys {
  final String publicKey;
  final String privateKey;

  const AccountKeys(this.publicKey, this.privateKey);

  Map<String, dynamic> toJson() => {
    'publicKey': publicKey,
    'privateKey': privateKey
  };
}
