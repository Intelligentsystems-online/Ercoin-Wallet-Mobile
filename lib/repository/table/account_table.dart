class AccountTable {
  static final tableName = "Account";
  static final publicKeyField = "publicKey";
  static final privateKeyField = "privateKey";
  static final nameField = "name";

  static final String createTableQuery =
      "CREATE TABLE $tableName ($publicKeyField varchar(255) PRIMARY KEY, $privateKeyField varchar(255), $nameField varchar(255));";
}