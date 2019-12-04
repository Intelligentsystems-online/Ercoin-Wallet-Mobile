import 'dart:async';

import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/utils/service/account/active_account_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/list/transaction_list_service.dart';

//TODO(DI)
class AccountInfoInteractor {
  final _activeAccountService = ActiveAccountService();
  final _transactionListService = TransactionListService();

  Future<AccountWithBalance> obtainActiveAccountWithBalance() => _activeAccountService.obtainActiveAccountWithBalance();

  Future<List<Transaction>> obtainRecentTransactions() async {
    final activeAccountPk = await _activeAccountService.obtainActiveAccountPk();
    final transactions = await _transactionListService.obtainTransactionsFor(activeAccountPk);

    transactions.sort(_compareByTimestamp);

    return _obtainLimitedTransactions(5, transactions);
  }

  int _compareByTimestamp(Transaction t1, Transaction t2) => t2.timestamp.compareTo(t1.timestamp);

  List<Transaction> _obtainLimitedTransactions(int limit, List<Transaction> transactions) =>
      (transactions.length < limit) ? transactions.sublist(0, transactions.length) : transactions.sublist(0, limit);
}