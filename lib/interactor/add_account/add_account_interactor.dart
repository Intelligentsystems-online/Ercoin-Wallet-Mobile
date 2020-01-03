import 'dart:async';

import 'package:ercoin_wallet/const_values/shared_preferences_const_values.dart';
import 'package:ercoin_wallet/model/local_account/local_account_data.dart';
import 'package:ercoin_wallet/service/common/key_generator_service.dart';
import 'package:ercoin_wallet/service/common/shared_preferences_service.dart';


class AddAccountInteractor {
  final KeyGeneratorService _keyGeneratorService;
  final SharedPreferencesService _sharedPreferencesService;


  AddAccountInteractor(this._keyGeneratorService, this._sharedPreferencesService);

  Future<LocalAccountKeys> generateAccountKeys() => _keyGeneratorService.generateAccountKeys();

  Future<bool> shouldDisplayRegistrationInfo() async {
    final result = await _sharedPreferencesService.getSharedPreference(registrationAlertPreferenceKey);

    if(result.isEmpty || result == registrationAlertAliveValue)
      return true;
    else
      return false;
  }
}
