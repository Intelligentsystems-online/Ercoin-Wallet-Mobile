import 'package:ercoin_wallet/utils/ByteConverter.dart';
import 'package:ercoin_wallet/utils/DateUtil.dart';
import 'package:ercoin_wallet/utils/KeyGenerator.dart';
import 'package:ercoin_wallet/utils/service/common/shared_preferences_util.dart';
import 'package:injector/injector.dart';

class CommonUtilsConfiguration {
  configure() {
    Injector _injector = Injector.appInstance;

    _injector.registerSingleton<ByteConverter>((_) => ByteConverter());
    _injector.registerSingleton<DateUtil>((_) => DateUtil());
    _injector.registerSingleton<KeyGenerator>((_) => KeyGenerator());
    _injector.registerSingleton<SharedPreferencesUtil>((_) => SharedPreferencesUtil());
  }
}