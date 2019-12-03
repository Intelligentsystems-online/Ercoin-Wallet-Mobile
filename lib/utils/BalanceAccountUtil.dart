
import 'dart:typed_data';

class BalanceAccountUtil
{
  double obtainBalanceValue(Uint8List accountDataBytes) {
    ByteBuffer buffer = _balanceBytesFrom(accountDataBytes).buffer;

    return ByteData
        .view(buffer)
        .getInt64(0) / 1000000;
  }

  Uint8List _balanceBytesFrom(Uint8List accountDataBytes) => accountDataBytes.sublist(4, 12);
}
