class AccountTable {
  static final tableName = "Account";
  static final publicKeyProperty = "publicKey";
  static final privateKeyProperty = "privateKey";
  static final nameProperty = "name";

  static final String createTableQuery =
      "CREATE TABLE $tableName ($publicKeyProperty varchar(255) PRIMARY KEY, $privateKeyProperty varchar(255), $nameProperty varchar(255));";
}