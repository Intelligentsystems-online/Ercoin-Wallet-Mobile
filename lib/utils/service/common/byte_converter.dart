import 'dart:typed_data';

//TODO(Search for lib converting big endian or make some refactor here)
class ByteConverter
{
  Uint8List convertIntToBytes(BigInt number, int bytesSize) {
    Uint8List bytes = _writeBigInt(number);
    Uint8List result = Uint8List(bytesSize);
    var size = bytes.length;

    if((bytesSize - size) == 0) {
      for(int i = 0; i < bytesSize; i++) {
        result[i] = bytes[bytesSize - i - 1];
      }
    }
    else {
      for(int i = 0; i < bytesSize; i++) {
        if(i < (bytesSize - size)) {
          result[i] = 0;
        }
        else {
          result[i] = bytes[bytesSize - i - 1];
        }
      }
    }
    return result;
  }

  Uint8List _writeBigInt(BigInt number) {
    int bytes = (number.bitLength + 7) >> 3;
    var b256 = new BigInt.from(256);
    var result = new Uint8List(bytes);
    for (int i = 0; i < bytes; i++) {
      result[i] = number.remainder(b256).toInt();
      number = number >> 8;
    }
    return result;
  }
}