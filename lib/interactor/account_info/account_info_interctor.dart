import 'dart:async';

import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/model/account_info.dart';
import 'package:ercoin_wallet/utils/service/account/active_local_account_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/list/transaction_list_service.dart';

class AccountInfoInteractor {
  final ActiveAccountService _activeAccountService;
  final TransactionListService _transactionListService;

  AccountInfoInteractor(this._activeAccountService, this._transactionListService);

  Future<AccountInfo> obtainActiveAccountWithBalance() => _activeAccountService.obtainActiveAccountInfo();

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
