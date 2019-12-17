import 'package:ercoin_wallet/model/address.dart';
import 'package:ercoin_wallet/model/local_account.dart';
import 'package:ercoin_wallet/model/named_address.dart';
import 'package:ercoin_wallet/model/private_key.dart';

class LocalAccountDb {
  static const tableName = "LocalAccount";
  static const publicKeyRow = "publicKey";
  static const privateKeyRow = "privateKey";
  static const nameRow = "name";

  static const createTableQuery = "CREATE TABLE $tableName(" +
      "$publicKeyRow varchar(${Address.requiredPublicKeyLength}) PRIMARY KEY, " +
      "$privateKeyRow varchar(${PrivateKey.requiredLength}), " +
      "$nameRow varchar(255));";

  static const whereNameLikeClause = "WHERE $nameRow LIKE ?";
  static const wherePublicKeyIsClause = "WHERE $publicKeyRow = ?";
  
  static Map<String, dynamic> serialize(LocalAccount data) => {
    publicKeyRow: data.namedAddress.address.publicKey,
    privateKeyRow: data.privateKey.privateKey,
    nameRow: data.namedAddress,
  };

  static LocalAccount deserialize(Map<String, dynamic> data) => LocalAccount(
    namedAddress: NamedAddress(
        address: Address(publicKey: data[publicKeyRow]),
      name: data[nameRow],
    ),
    privateKey: PrivateKey(privateKey: data[privateKeyRow]),
  );
}
