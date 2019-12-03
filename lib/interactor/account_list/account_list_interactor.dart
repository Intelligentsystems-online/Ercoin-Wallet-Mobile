import 'dart:async';
import 'dart:convert';

import 'package:ercoin_wallet/utils/SharedPreferencesUtil.dart';

import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/ApiConsumer.dart';
import 'package:ercoin_wallet/utils/BalanceAccountUtil.dart';

//TODO(DI)
class AccountListInteractor {
  final _sharedPreferencesUtil = SharedPreferencesUtil();
  final _accountRepository = AccountRepository();
  final _apiConsumer = ApiConsumer();
  final _balanceAccountUtil = BalanceAccountUtil();

  Future<List<AccountWithBalance>> obtainAccountsWithBalance() async {
    final accounts = await _accountRepository.findAll();
    final futureAccounts = accounts.map((account) => toAccountWithBalance(account));

    return Future.wait(futureAccounts);
  }

  Future<AccountWithBalance> toAccountWithBalance(Account account) async {
    final accountDataBase64 = await _apiConsumer.fetchAccountDataBase64For(account.publicKey);
    final accountBalance = _balanceAccountUtil.obtainBalanceValue(base64.decode(accountDataBase64));

    return AccountWithBalance(account, accountBalance);
  }

  Future<String> obtainActiveAccountPk() => _sharedPreferencesUtil.getSharedPreference("active_account");

  Future<void> activateAccount(String publicKey) => _sharedPreferencesUtil.setSharedPreference("active_account", publicKey);
}