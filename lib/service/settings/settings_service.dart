import 'package:ercoin_wallet/const_values/api_const_values.dart';
import 'package:ercoin_wallet/const_values/shared_preferences_const_values.dart';
import 'package:ercoin_wallet/service/common/shared_preferences_service.dart';

class SettingsService {
  final SharedPreferencesService _sharedPreferencesService;

  SettingsService(this._sharedPreferencesService);

  Future<void> persistNodeUri(String uri) async =>
      _sharedPreferencesService.setSharedPreference(nodeUriPreferenceKey, uri);


  Future<String> obtainNodeUri() async {
    final nodeUri = await _sharedPreferencesService.getSharedPreference(nodeUriPreferenceKey);

    return nodeUri.isEmpty ? defaultNodeUri : nodeUri;
  }
}