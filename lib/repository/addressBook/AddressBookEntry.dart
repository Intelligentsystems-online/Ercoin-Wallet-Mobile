class AddressBookEntry
{
  final String publicKey;
  final String accountName;

  AddressBookEntry(this.publicKey, this.accountName);

  factory AddressBookEntry.fromMap(Map<String, dynamic> json) => AddressBookEntry(
    json['publicKey'],
    json['accountName']
  );

  Map<String, dynamic> toMap() => {
    'publicKey' : publicKey,
    'accountName' : accountName
  };
}