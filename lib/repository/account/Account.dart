class Account
{
  final String publicKey;
  final String privateKey;
  final String accountName;

  Account(this.publicKey, this.privateKey, this.accountName);

  factory Account.fromMap(Map<String, dynamic> json) => new Account(
    json["publicKey"],
    json["privateKey"],
    json["accountName"]);

  Map<String, dynamic> toMap() => {
    'publicKey' : publicKey,
    'privateKey' : privateKey,
    'accountName' : accountName
  };
}
