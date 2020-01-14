import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


@immutable
class CoinsAmount extends Equatable {
  final double _ercoin;

  CoinsAmount._(this._ercoin);

  static CoinsAmount ofErcoin(double ercoin) {
   if(ercoin >= 0.0)
     return CoinsAmount._(ercoin);
   else
     throw FormatException("Coins amount should be greater than zero.");
  }

  static CoinsAmount ofMicroErcoin(int microErcoin) =>
    ofErcoin(microErcoin / 1000000.0);

  int get microErcoin => (_ercoin * 1000000).floor();

  double get ercoin => _ercoin;

  String get ercoinFixed => _ercoin.toStringAsFixed(6);

  @override
  get props => [_ercoin];
}
