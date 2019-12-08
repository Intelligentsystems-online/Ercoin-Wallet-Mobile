import 'dart:async';
import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/model/account_keys.dart';
import 'package:ercoin_wallet/model/account_info.dart';
import 'package:ercoin_wallet/model/account_status.dart';
import 'package:ercoin_wallet/model/api_response_status.dart';
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

  Future<List<AccountInfo>> obtainAccountsInfo() async {
    final accounts = await _accountRepository.findAll();
    final futureAccounts = accounts.map((account) => _toAccountInfo(account));

    return await Future.wait(futureAccounts);
  }

  Future<AccountInfo> _toAccountInfo(Account account) async {
    final apiResponse = await _apiConsumerService.fetchAccountDataBase64For(account.publicKey);

    return _commonAccountUtil.obtainAccountInfoFrom(apiResponse, account);
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