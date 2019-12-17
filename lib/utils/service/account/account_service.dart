import 'dart:async';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/model/account_keys.dart';
import 'package:ercoin_wallet/model/account_info.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/service/account/common_account_util.dart';
import 'package:ercoin_wallet/utils/service/api/api_consumer_service.dart';
import 'package:ercoin_wallet/utils/service/common/key_generator.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

class AccountService {
  final CommonAccountUtil _commonAccountUtil;
  final AccountRepository _accountRepository;
  final ApiConsumerService _apiConsumerService;
  final KeyGenerator _keyGenerator;

  AccountService(this._commonAccountUtil, this._accountRepository, this._apiConsumerService, this._keyGenerator);

  Future<List<Account>> obtainAccounts() => _accountRepository.findAll();

  Future<List<AccountInfo>> obtainAccountsInfo() async {
    final accounts = await _accountRepository.findAll();
    final futureAccounts = accounts.map((account) => _toAccountInfo(account));

    return await Future.wait(futureAccounts);
  }

  Future<AccountInfo> _toAccountInfo(Account account) async {
    final apiResponse = await _apiConsumerService.fetchAccountDataBase64For(account.publicKey);

    return _commonAccountUtil.obtainAccountInfoFrom(apiResponse, account);
  }

  Future<Account> saveAccount(String publicKey, String privateKey, String accountName) =>
      _accountRepository.createAccount(publicKey, privateKey, accountName);

  Future<AccountKeys> generateAccountKeys() async {
    final keyPair = await _keyGenerator.generateKeyPair();

    return _accountKeysFrom(keyPair);
  }

  AccountKeys _accountKeysFrom(KeyPair keyPair) => AccountKeys(
      hex.encode(keyPair.publicKey),
      hex.encode(keyPair.secretKey)
  );
}
