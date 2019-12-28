import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/transfer/transfer_data.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/model/transfer/transfer_direction.dart';
import 'package:flutter/foundation.dart';


@immutable
class Transfer {
  final TransferData data;
  final TransferDirection direction;
  final NamedAddress foreignAddressNamed;

  const Transfer({
    @required this.data,
    @required this.direction,
    this.foreignAddressNamed
  });
}
