import 'dart:async';

import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/service/account/common_account_util.dart';

class AccountService {
  final _commonAccountUtil = CommonAccountUtil();
  final _accountRepository = AccountRepository();

  Future<List<AccountWithBalance>> obtainAccountsWithBalance() async {
    final accounts = await _accountRepository.findAll();
    final futureAccounts = accounts.map((account) => _commonAccountUtil.toAccountWithBalance(account));

    return Future.wait(futureAccounts);
  }

  Future<int> saveAccount(Account account) => _accountRepository.createAccount(account);
}