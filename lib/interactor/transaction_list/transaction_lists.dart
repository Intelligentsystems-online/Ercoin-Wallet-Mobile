import 'package:ercoin_wallet/model/Transaction.dart';

class TransactionLists {
  final List<Transaction> inbound;
  final List<Transaction> outbound;
  final List<Transaction> all;

  TransactionLists(this.inbound, this.outbound, this.all);
}