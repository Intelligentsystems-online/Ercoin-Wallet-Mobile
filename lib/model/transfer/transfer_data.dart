import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';
import 'package:ercoin_wallet/model/transfer/transfer_direction.dart';
import 'package:flutter/foundation.dart';

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
