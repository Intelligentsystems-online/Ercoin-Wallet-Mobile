import 'dart:async';

import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/model/TransactionFactory.dart';
import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/utils/ApiConsumer.dart';
import 'package:ercoin_wallet/utils/SharedPreferencesUtil.dart';
import 'package:ercoin_wallet/utils/service/account/active_account_service.dart';

//TODO(DI)
class AccountInfoInteractor {
  final _activeAccountService = ActiveAccountService();

  final _sharedPreferencesUtil = SharedPreferencesUtil();
  final _apiConsumer = ApiConsumer();
  final _transactionFactory = TransactionFactory();

  Future<AccountWithBalance> obtainActiveAccountWithBalance() => _activeAccountService.obtainActiveAccountWithBalance();

  Future<List<Transaction>> obtainRecentTransactions() async {
    final activeAccountPk = await _sharedPreferencesUtil.getSharedPreference("active_account");
    final outboundTransactionsBase64 = await _apiConsumer.fetchOutboundTransactionBase64ListFor(activeAccountPk);
    final incomingTransactionsBase64 = await _apiConsumer.fetchIncomingTransactionBase64ListFor(activeAccountPk);

    final outboundTransactions = _obtainTransactionsFrom(outboundTransactionsBase64);
    outboundTransactions.sort((t1, t2) => t2.timestamp.compareTo(t1.timestamp));
    final incomingTransactions = _obtainTransactionsFrom(incomingTransactionsBase64);
    incomingTransactions.sort((t1, t2) => t2.timestamp.compareTo(t1.timestamp));

    final limitedOutboundTransactions = _obtainLimitedTransactions(3, outboundTransactions);
    final limitedIncomingTransactions = _obtainLimitedTransactions(3, incomingTransactions);

    final recentTransactions = List<Transaction>();

    recentTransactions.addAll(limitedOutboundTransactions);
    recentTransactions.addAll(limitedIncomingTransactions);
    recentTransactions.sort((t1, t2) => t2.timestamp.compareTo(t1.timestamp));

    return recentTransactions;
  }

  List<Transaction> _obtainLimitedTransactions(int limit, List<Transaction> transactions) =>
      (transactions.length < limit) ? transactions.sublist(0, transactions.length) : transactions.sublist(0, limit);

  List<Transaction> _obtainTransactionsFrom(List<String> transactionsBase64) => transactionsBase64
      .map((trxBase64) => _transactionFactory.createFromBase64(trxBase64))
      .toList();
}