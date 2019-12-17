import 'package:ercoin_wallet/model/address.dart';
import 'package:ercoin_wallet/model/api/transfer_data.dart';
import 'package:ercoin_wallet/model/coins_amount.dart';
import 'package:ercoin_wallet/model/local_account.dart';
import 'package:ercoin_wallet/model/named_address.dart';
import 'package:ercoin_wallet/model/transfer_direction.dart';
import 'package:flutter/cupertino.dart';

@immutable
class Transfer {
  final TransferData data;
  final TransferDirection direction;
  final LocalAccount localAccount;
  final NamedAddress foreignAddressNamed;

  const Transfer({
    @required this.data,
    @required this.direction,
    @required this.localAccount,
    this.foreignAddressNamed
  });

  get foreignAddress => direction == TransferDirection.IN ? data.from : data.to;
}
