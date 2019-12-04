import 'dart:convert';

import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/utils/ApiConsumer.dart';
import 'package:ercoin_wallet/utils/BalanceAccountUtil.dart';

class CommonAccountUtil {
  final _apiConsumer = ApiConsumer();
  final _balanceAccountUtil = BalanceAccountUtil();

  Future<AccountWithBalance> toAccountWithBalance(Account account) async {
    final accountDataBase64 = await _apiConsumer.fetchAccountDataBase64For(account.publicKey);
    final accountBalance = _balanceAccountUtil.obtainBalanceValue(base64.decode(accountDataBase64));

    return AccountWithBalance(account, accountBalance);
  }
}