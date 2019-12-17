class Account
{
  final String publicKey;
  final String privateKey;
  final String name;

  Account(this.publicKey, this.privateKey, this.name);

  factory Account.fromMap(Map<String, dynamic> json) => new Account(
    json["publicKey"],
    json["privateKey"],
    json["name"]);

  Map<String, dynamic> toMap() => {
    'publicKey' : publicKey,
    'privateKey' : privateKey,
    'name' : name
  };
}
