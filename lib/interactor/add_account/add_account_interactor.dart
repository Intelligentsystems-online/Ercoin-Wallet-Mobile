import 'dart:async';

import 'package:ercoin_wallet/model/account_keys.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

// TODO(Interactor)
class AddAccountInteractor {
  Future<AccountKeys> generateAccountKeys() async => AccountKeys("pubkey", "privkey");
}
