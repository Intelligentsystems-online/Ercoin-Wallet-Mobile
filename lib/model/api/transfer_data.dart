import 'package:ercoin_wallet/model/address.dart';
import 'package:ercoin_wallet/model/coins_amount.dart';
import 'package:flutter/cupertino.dart';

class TransferData {
  final CoinsAmount amount;
  final Address from;
  final Address to;
  final String message;
  final DateTime timestamp;

  const TransferData({
    @required this.amount,
    @required this.from,
    @required this.to,
    @required this.message,
    @required this.timestamp,
  });
}
