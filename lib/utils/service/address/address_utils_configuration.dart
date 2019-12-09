import 'package:ercoin_wallet/repository/address/AddressRepository.dart';
import 'package:ercoin_wallet/utils/service/address/address_service.dart';
import 'package:injector/injector.dart';

class AddressUtilsConfiguration {
  Injector _injector = Injector.appInstance;

  configure() {
    _injector.registerSingleton<AddressService>((injector) => AddressService(
      addressRepository: injector.getDependency<AddressRepository>()
    ));
  }
}