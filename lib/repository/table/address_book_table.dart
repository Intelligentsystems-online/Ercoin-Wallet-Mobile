class AddressBookTable {
  static final tableName = "AddressBook";
  static final publicKeyField = "publicKey";
  static final nameField = "name";

  static final createTableQuery = "CREATE TABLE $tableName ($publicKeyField varchar(255) PRIMARY KEY, $nameField varchar(255));";
}