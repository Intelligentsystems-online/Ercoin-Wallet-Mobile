import 'package:ercoin_wallet/utils/service/api/api_consumer_service.dart';
import 'package:ercoin_wallet/utils/service/api/code_mapper_util.dart';
import 'package:ercoin_wallet/utils/service/api/uri_factory.dart';
import 'package:injector/injector.dart';

class ApiUtilsConfiguration {
  Injector _injector = Injector.appInstance;

  configure() {
    _injector.registerSingleton<CodeMapperUtil>((_) => CodeMapperUtil());
    _injector.registerSingleton<UriFactory>((_) => UriFactory());
    _injector.registerSingleton<ApiConsumerService>((injector) => ApiConsumerService(
      codeMapperUtil: injector.getDependency<CodeMapperUtil>(),
      uriFactory: injector.getDependency<UriFactory>()
    ));
  }
}