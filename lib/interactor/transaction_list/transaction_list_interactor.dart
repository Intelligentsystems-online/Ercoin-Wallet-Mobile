import 'dart:async';

import 'package:ercoin_wallet/interactor/transaction_list/transaction_lists.dart';
import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/utils/service/account/active_account_service.dart';
import 'package:ercoin_wallet/utils/service/transaction/list/transaction_list_service.dart';

class TransactionListInteractor {
  final ActiveAccountService _activeAccountService;
  final TransactionListService _transactionListService;

  TransactionListInteractor(this._activeAccountService, this._transactionListService);

  Future<TransactionLists> obtainTransactionLists() async {
    final activeAccountPk = await _activeAccountService.obtainActiveAccountPk();
    final inboundTransactions = await _transactionListService.obtainIncomingTransactionsFor(activeAccountPk);
    final outboundTransactions = await _transactionListService.obtainOutboundTransactionsFor(activeAccountPk);
    final allTransactions = inboundTransactions + outboundTransactions;

    inboundTransactions.sort(_compareByTimestamp);
    outboundTransactions.sort(_compareByTimestamp);
    allTransactions.sort(_compareByTimestamp);

    return TransactionLists(inboundTransactions, outboundTransactions, allTransactions);
  }

  int _compareByTimestamp(Transaction t1, Transaction t2) => t2.timestamp.compareTo(t1.timestamp);
}
