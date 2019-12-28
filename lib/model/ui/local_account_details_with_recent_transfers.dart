import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:flutter/foundation.dart';

@immutable
class LocalAccountDetailsWithRecentTransfers {
  final LocalAccountDetails details;
  final List<Transfer> recentTransfers;

  const LocalAccountDetailsWithRecentTransfers({@required this.details, @required this.recentTransfers});
}
