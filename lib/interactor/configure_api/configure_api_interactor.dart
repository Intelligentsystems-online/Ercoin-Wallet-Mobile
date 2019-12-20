import 'package:ercoin_wallet/const_values/api_const_values.dart';
import 'package:ercoin_wallet/model/api/api_response_status.dart';
import 'package:ercoin_wallet/service/api/api_consumer_service.dart';
import 'package:ercoin_wallet/service/common/shared_preferences_service.dart';
import 'package:ercoin_wallet/const_values/shared_preferences_const_values.dart';

class ConfigureApiInteractor {
  final SharedPreferencesService _sharedPreferencesService;
  final ApiConsumerService _apiConsumerService;

  ConfigureApiInteractor(this._sharedPreferencesService, this._apiConsumerService);

  Future<String> validateNodeUri(String uri) async {
   if(uri.isEmpty)
     return "Value cannot be empty";
   else if(!uri.startsWith("https://"))
     return "Value should start with https://";
   else if(await isCorrectNodeUri(uri) == ApiResponseStatus.NODE_NOT_AVAILABLE)
     return "Node not available";
   else
     return null;
  }

  Future<ApiResponseStatus> isCorrectNodeUri(String uri) => _apiConsumerService.healthCheck(uri);

  Future<void> persistNodeUri(String uri) async =>
    _sharedPreferencesService.setSharedPreference(nodeUriPreferenceKey, uri);

  Future<String> obtainNodeUri() async {
    final nodeUri = await _sharedPreferencesService.getSharedPreference(nodeUriPreferenceKey);

    return nodeUri.isEmpty ? defaultNodeUri : nodeUri;
  }
}