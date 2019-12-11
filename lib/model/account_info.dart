import 'package:ercoin_wallet/model/account_status.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';

class AccountInfo {
  final Account account;
  final double balance;
  final AccountStatus status;

  int get balanceMicro => (balance * 1000000).round();

  const AccountInfo(this.account, this.balance, this.status);
}
