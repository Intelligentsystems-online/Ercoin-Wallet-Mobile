import 'dart:async';

import 'package:ercoin_wallet/model/local_account/local_account_data.dart';
import 'package:ercoin_wallet/service/common/key_generator_service.dart';


class AddAccountInteractor {
  final KeyGeneratorService _keyGeneratorService;

  AddAccountInteractor(this._keyGeneratorService);

  Future<LocalAccountKeys> generateAccountKeys() => _keyGeneratorService.generateAccountKeys();
}
