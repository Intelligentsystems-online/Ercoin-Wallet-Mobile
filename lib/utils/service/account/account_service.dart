import 'dart:async';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/model/account_keys.dart';
import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/service/account/common_account_util.dart';
import 'package:ercoin_wallet/utils/service/common/key_generator.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

class AccountService {
  final _commonAccountUtil = CommonAccountUtil();
  final _accountRepository = AccountRepository();
  final _keyGenerator = KeyGenerator();

  Future<List<AccountWithBalance>> obtainAccountsWithBalance() async {
    final accounts = await _accountRepository.findAll();
    final futureAccounts = accounts.map((account) => _commonAccountUtil.toAccountWithBalance(account));

    return Future.wait(futureAccounts);
  }

  Future<int> saveAccount(Account account) => _accountRepository.createAccount(account);

  Future<AccountKeys> generateAccountKeys() async {
    final keyPair = await _keyGenerator.generateKeyPair();

    return _accountKeysFrom(keyPair);
  }

  AccountKeys _accountKeysFrom(KeyPair keyPair) => AccountKeys(
      hex.encode(keyPair.publicKey),
      hex.encode(keyPair.secretKey)
  );
}