import 'package:ercoin_wallet/const_values/api_const_values.dart';
import 'package:ercoin_wallet/service/common/shared_preferences_service.dart';
import 'package:ercoin_wallet/const_values/shared_preferences_const_values.dart';

class ConfigureApiInteractor {
  final SharedPreferencesService _sharedPreferencesService;

  ConfigureApiInteractor(this._sharedPreferencesService);

  String validateNodeUri(String uri) {
   if(uri.isEmpty)
     return "Value cannot be empty";
   else if(!uri.startsWith("https://"))
     return "Value should start with https://";
   else
     return null;
  }

  Future<void> persistNodeUri(String uri) async =>
    _sharedPreferencesService.setSharedPreference(nodeUriPreferenceKey, uri);

  Future<String> obtainNodeUri() async {
    final nodeUri = await _sharedPreferencesService.getSharedPreference(nodeUriPreferenceKey);

    return nodeUri.isEmpty ? defaultNodeUri : nodeUri;
  }
}