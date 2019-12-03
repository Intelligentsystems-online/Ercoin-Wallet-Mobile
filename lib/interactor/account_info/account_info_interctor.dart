import 'dart:async';
import 'dart:convert';

import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/model/TransactionFactory.dart';
import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/ApiConsumer.dart';
import 'package:ercoin_wallet/utils/BalanceAccountUtil.dart';
import 'package:ercoin_wallet/utils/SharedPreferencesUtil.dart';

//TODO(DI)
class AccountInfoInteractor {
  final _sharedPreferencesUtil = SharedPreferencesUtil();
  final _apiConsumer = ApiConsumer();
  final _balanceAccountUtil = BalanceAccountUtil();
  final _accountRepository = AccountRepository();
  final _transactionFactory = TransactionFactory();

  Future<AccountWithBalance> obtainActiveAccountWithBalance() async {
    final activeAccountPk = await _sharedPreferencesUtil.getSharedPreference("active_account");
    final account = await _accountRepository.findByPublicKey(activeAccountPk);
    final accountDataBase64 = await _apiConsumer.fetchAccountDataBase64For(activeAccountPk);
    final accountBalance = _balanceAccountUtil.obtainBalanceValue(base64.decode(accountDataBase64));

    return AccountWithBalance(account, accountBalance);
  }

  Future<List<Transaction>> obtainRecentOutboundTransactions() async {
    final activeAccountPk = await _sharedPreferencesUtil.getSharedPreference("active_account");
    final transactionsBase64 = await _apiConsumer.fetchOutboundTransactionBase64ListFor(activeAccountPk);

    return _obtainTransactionsFrom(transactionsBase64);
  }

  Future<List<Transaction>> obtainRecentIncomingTransactions() async {
    final activeAccountPk = await _sharedPreferencesUtil.getSharedPreference("active_account");
    final transactionsBase64 = await _apiConsumer.fetchIncomingTransactionBase64ListFor(activeAccountPk);

    return _obtainTransactionsFrom(transactionsBase64);
  }

  List<Transaction> _obtainTransactionsFrom(List<String> transactionsBase64) => transactionsBase64
      .map((trxBase64) => _transactionFactory.createFromBase64(trxBase64))
      .toList();
}