class AddressBookEntry
{
  final String publicKey;
  final String name;

  AddressBookEntry(this.publicKey, this.name);

  factory AddressBookEntry.fromMap(Map<String, dynamic> json) => AddressBookEntry(
    json['publicKey'],
    json['name']
  );

  Map<String, dynamic> toMap() => {
    'publicKey' : publicKey,
    'name' : name
  };
}