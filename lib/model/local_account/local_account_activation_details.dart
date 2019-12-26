import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:flutter/cupertino.dart';

@immutable
class LocalAccountActivationDetails {
  final LocalAccountDetails details;
  final bool isActive;

  const LocalAccountActivationDetails({
    @required this.details,
    @required this.isActive,
  });
}
