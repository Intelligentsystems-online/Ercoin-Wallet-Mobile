import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';

import '../transfer.dart';
import '../transfer_data.dart';
import '../transfer_direction.dart';

class Transfers {

  static R byDirectionSupplied<R>(TransferDirection direction, {R onIn, R onOut}) =>
      direction == TransferDirection.IN ? onIn : onOut;

  static R byDirection<R>(Transfer transfer, {R onIn, R onOut}) =>
      byDirectionSupplied(transfer.direction, onIn: onIn, onOut: onOut);

  static Address foreignAddressWithDirection(TransferData data, TransferDirection direction) =>
      byDirectionSupplied(direction, onIn: data.from, onOut: data.to);

  static Address foreignAddress(Transfer transfer) => foreignAddressWithDirection(transfer.data, transfer.direction);

  static String foreignAddressNameOrPublicKey(Transfer transfer) =>
      transfer.foreignAddressNamed?.name ?? Transfers.foreignAddress(transfer).publicKey;

  static double deltaAmountErcoin(Transfer transfer) =>
      transfer.data.amount.ercoin * byDirection(transfer, onIn: 1, onOut: -1);

  static String deltaAmountErcoinSigned(Transfer transfer) {
    final delta = deltaAmountErcoin(transfer);
    final amount = transfer.data.amount.ercoinFixed;

    return delta < 0 ? "$amount" : "+$amount";
  }
}
