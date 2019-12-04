import 'dart:async';
import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/model/account_keys.dart';
import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/service/account/common_account_util.dart';
import 'package:ercoin_wallet/utils/service/api/api_consumer_service.dart';
import 'package:ercoin_wallet/utils/service/common/key_generator.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

//TODO(DI)
class AccountService {
  final _commonAccountUtil = CommonAccountUtil();
  final _accountRepository = AccountRepository();
  final _keyGenerator = KeyGenerator();
  final _apiConsumerService = ApiConsumerService();

  Future<List<AccountWithBalance>> obtainAccountsWithBalance() async {
    final accounts = await _accountRepository.findAll();
    final futureAccounts = accounts.map((account) => _toAccountWithBalance(account));

    return await Future.wait(futureAccounts);
  }

  Future<AccountWithBalance> _toAccountWithBalance(Account account) async {
    final accountDataBase64 = await _apiConsumerService.fetchAccountDataBase64For(account.publicKey);
    final accountBalance = _commonAccountUtil.obtainBalanceValue(base64.decode(accountDataBase64));

    return AccountWithBalance(account, accountBalance);
  }

  Future<Account> saveAccount(Account account) async {
    await _accountRepository.createAccount(account);

    return account;
  }
  Future<AccountKeys> generateAccountKeys() async {
    final keyPair = await _keyGenerator.generateKeyPair();

    return _accountKeysFrom(keyPair);
  }

  AccountKeys _accountKeysFrom(KeyPair keyPair) => AccountKeys(
      hex.encode(keyPair.publicKey),
      hex.encode(keyPair.secretKey)
  );
}