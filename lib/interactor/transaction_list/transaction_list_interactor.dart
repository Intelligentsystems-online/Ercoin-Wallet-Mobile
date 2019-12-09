import 'dart:async';

import 'package:ercoin_wallet/model/Transaction.dart';

class TransactionListInteractor {
  /// returns 3-item list: [allTransactions, inboundTransactions, outgoingTransactions], all sorted by date
  Future<List<List<Transaction>>> obtainTransactionLists() async {
    return [[Transaction("a", "b", 10, "xd", 0), Transaction("a", "b", 10, "xd", 0)], [Transaction("a", "b", 10, "xd", 0)], [Transaction("a", "b", 10, "xd", 0)]];
  }
}
