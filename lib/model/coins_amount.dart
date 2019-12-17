import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class CoinsAmount extends Equatable {
  final double ercoin;

  const CoinsAmount({@required this.ercoin}) : assert(ercoin >= 0);
  static ofMicroErcoin(int microErcoin) => CoinsAmount(ercoin: microErcoin / 1000000.0);

  get microErcoin => ercoin * 1000000;

  @override
  get props => [ercoin];
}
