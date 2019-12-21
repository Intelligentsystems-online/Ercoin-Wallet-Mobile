import 'package:ercoin_wallet/model/api/api_health_status.dart';
import 'package:ercoin_wallet/service/api/api_consumer_service.dart';
import 'package:ercoin_wallet/service/settings/settings_service.dart';

class SettingsInteractor {
  final SettingsService _settingsService;
  final ApiConsumerService _apiConsumerService;

  SettingsInteractor(this._settingsService, this._apiConsumerService);

  Future<String> validateNodeUri(String uri) async {
   if(uri.isEmpty)
     return "Value cannot be empty";
   else if(!uri.startsWith("https://"))
     return "Value should start with https://";
   else if(!await isCorrectNodeUri(uri))
     return "Node not available";
   else
     return null;
  }

  Future<bool> isCorrectNodeUri(String uri) async =>
      await _apiConsumerService.healthCheck(uri) == ApiHealthStatus.NODE_AVAILABLE ? true : false;

  Future<void> persistNodeUri(String uri) async => _settingsService.persistNodeUri(uri);

  Future<String> obtainNodeUri() => _settingsService.obtainNodeUri();
}