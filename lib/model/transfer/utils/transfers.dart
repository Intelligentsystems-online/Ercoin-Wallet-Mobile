import 'package:ercoin_wallet/model/base/address.dart';

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

  static int deltaAmountMicroErcoin(Transfer transfer) =>
      transfer.data.amount.microErcoin * byDirection(transfer, onIn: 1, onOut: -1);

  static String deltaAmountMicroErcoinSigned(Transfer transfer) {
    final delta = deltaAmountMicroErcoin(transfer);
    return delta < 0 ? "$delta" : "+$delta";
  }
}
