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

  Future<List<Transaction>> obtainRecentTransactions() async {
    final activeAccountPk = await _sharedPreferencesUtil.getSharedPreference("active_account");
    final outboundTransactionsBase64 = await _apiConsumer.fetchOutboundTransactionBase64ListFor(activeAccountPk);
    final incomingTransactionsBase64 = await _apiConsumer.fetchIncomingTransactionBase64ListFor(activeAccountPk);

    final outboundTransactions = _obtainTransactionsFrom(outboundTransactionsBase64);
    final incomingTransactions = _obtainTransactionsFrom(incomingTransactionsBase64);

    final limitedOutboundTransactions = _obtainLimitedTransactions(3, outboundTransactions);
    final limitedIncomingTransactions = _obtainLimitedTransactions(3, incomingTransactions);

    final recentTransactions = List<Transaction>();

    recentTransactions.addAll(limitedOutboundTransactions);
    recentTransactions.addAll(limitedIncomingTransactions);

    return recentTransactions;
  }

  List<Transaction> _obtainLimitedTransactions(int limit, List<Transaction> transactions) =>
      (transactions.length < limit) ? transactions.sublist(0, transactions.length) : transactions.sublist(0, limit);

  List<Transaction> _obtainTransactionsFrom(List<String> transactionsBase64) => transactionsBase64
      .map((trxBase64) => _transactionFactory.createFromBase64(trxBase64))
      .toList();
}