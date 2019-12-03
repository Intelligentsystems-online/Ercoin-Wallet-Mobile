
import 'dart:typed_data';

class BalanceAccountUtil
{
  double obtainBalanceValue(Uint8List accountDataBytes) {
    ByteBuffer buffer = _balanceBytesFrom(accountDataBytes).buffer;
    int microErcoinAmount = ByteData
        .view(buffer)
        .getInt64(0);

    return _ridOfMicroPrefixFrom(microErcoinAmount);
  }

  Uint8List _balanceBytesFrom(Uint8List accountDataBytes) => accountDataBytes.sublist(4, 12);

  double _ridOfMicroPrefixFrom(int amount) => amount / 1000000;
}
