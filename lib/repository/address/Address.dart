class Address
{
  final String publicKey;
  final String accountName;

  Address(this.publicKey, this.accountName);

  factory Address.fromMap(Map<String, dynamic> json) => Address(
    json['publicKey'],
    json['accountName']
  );

  Map<String, dynamic> toMap() => {
    'publicKey' : publicKey,
    'accountName' : accountName
  };
}