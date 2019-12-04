import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/utils/service/api/api_consumer.dart';

//TODO(DI)
class CommonAccountUtil {
  final _apiConsumer = ApiConsumer();

  Future<AccountWithBalance> toAccountWithBalance(Account account) async {
    final accountDataBase64 = await _apiConsumer.fetchAccountDataBase64For(account.publicKey);
    final accountBalance = _obtainBalanceValue(base64.decode(accountDataBase64));

    return AccountWithBalance(account, accountBalance);
  }

  double _obtainBalanceValue(Uint8List accountDataBytes) {
    ByteBuffer buffer = _balanceBytesFrom(accountDataBytes).buffer;
    int microErcoinAmount = ByteData
        .view(buffer)
        .getInt64(0);

    return _ridOfMicroPrefixFrom(microErcoinAmount);
  }

  Uint8List _balanceBytesFrom(Uint8List accountDataBytes) => accountDataBytes.sublist(4, 12);

  double _ridOfMicroPrefixFrom(int amount) => amount / 1000000;
}