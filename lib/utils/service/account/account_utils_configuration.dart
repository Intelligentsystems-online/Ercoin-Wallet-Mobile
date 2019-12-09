import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/service/account/account_service.dart';
import 'package:ercoin_wallet/utils/service/account/active_account_service.dart';
import 'package:ercoin_wallet/utils/service/account/common_account_util.dart';
import 'package:ercoin_wallet/utils/service/api/api_consumer_service.dart';
import 'package:ercoin_wallet/utils/service/common/key_generator.dart';
import 'package:ercoin_wallet/utils/service/common/shared_preferences_util.dart';
import 'package:injector/injector.dart';

class AccountUtilsConfiguration {
  Injector _injector = Injector.appInstance;

  configure() {
    _injector.registerSingleton<CommonAccountUtil>((_) => CommonAccountUtil());
    _injector.registerSingleton<ActiveAccountService>((injector) => ActiveAccountService(
      commonAccountUtil: injector.getDependency<CommonAccountUtil>(),
      accountRepository: injector.getDependency<AccountRepository>(),
      apiConsumerService: injector.getDependency<ApiConsumerService>(),
      sharedPreferencesUtil: injector.getDependency<SharedPreferencesUtil>()
    ));

    _injector.registerSingleton<AccountService>((injector) => AccountService(
      commonAccountUtil: injector.getDependency<CommonAccountUtil>(),
      accountRepository: injector.getDependency<AccountRepository>(),
      apiConsumerService: injector.getDependency<ApiConsumerService>(),
      keyGenerator: injector.getDependency<KeyGenerator>()
    ));
  }
}