class AddressBookTable {
  static final tableName = "AddressBook";
  static final publicKeyProperty = "publicKey";
  static final nameProperty = "name";

  static final createTableQuery = "CREATE TABLE $tableName ($publicKeyProperty varchar(255) PRIMARY KEY, $nameProperty varchar(255));";
}