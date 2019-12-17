import 'package:ercoin_wallet/model/address.dart';
import 'package:ercoin_wallet/model/named_address.dart';

class NamedAddressDb {
  static const tableName = "NamedAddress";
  static const publicKeyRow = "publicKey";
  static const nameRow = "name";

  static const createTableQuery = "CREATE TABLE $tableName (" +
      "$publicKeyRow varchar(${Address.requiredPublicKeyLength}) PRIMARY KEY, " +
      "$nameRow varchar(255));";

  static const whereNameLikeClause =
      "WHERE $nameRow LIKE ?";

  static Map<String, dynamic> serialize(NamedAddress data) => {
        publicKeyRow: data.address.publicKey,
        nameRow: data.name,
      };

  static NamedAddress deserialize(Map<String, dynamic> data) => NamedAddress(
        address: Address(publicKey: data[publicKeyRow]),
        name: data[nameRow],
      );
}
