class Address
{
  final String id;
  final String publicKey;
  final String accountName;

  Address(this.id, this.publicKey, this.accountName);

  factory Address.fromMap(Map<String, dynamic> json) => Address(
    json['id'],
    json['publicKey'],
    json['accountName']
  );

  Map<String, dynamic> toMap() => {
    'id' : id,
    'publicKey' : publicKey,
    'accountName' : accountName
  };
}