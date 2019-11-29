import 'package:ercoin_wallet/model/account_keys.dart';

class ImportAccountInteractor {
  Future<AccountKeys> importFromFile(String path) async { return AccountKeys("pubkey", "privkey"); }
}
