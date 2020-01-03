import 'package:ercoin_wallet/const_values/shared_preferences_const_values.dart';
import 'package:ercoin_wallet/service/common/shared_preferences_service.dart';

class RegistrationInfoInteractor {
  final SharedPreferencesService _sharedPreferencesService;

  const RegistrationInfoInteractor(this._sharedPreferencesService);

  Future persistRegistrationInfoRejected() async {
    await _sharedPreferencesService.setSharedPreference(registrationAlertPreferenceKey, registrationAlertRejectedValue);
  }
}