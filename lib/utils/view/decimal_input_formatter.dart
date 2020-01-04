import 'package:flutter/services.dart';

class DecimalInputFormatter extends TextInputFormatter {
  int _decimalRange;

  DecimalInputFormatter(this._decimalRange) {
    if(this._decimalRange <= 0) this._decimalRange = 2;

      _regExp = new RegExp("^([0-9]*([.][0-9]{0,$_decimalRange}){0,1}){0,1}\$");
  }

  RegExp _regExp;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) =>
    _regExp.hasMatch(newValue.text) ? newValue : oldValue;
}