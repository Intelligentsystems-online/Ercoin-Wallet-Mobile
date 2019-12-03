import 'package:ercoin_wallet/repository/account/Account.dart';

class AccountWithBalance {
  final Account account;
  final double balance;

  const AccountWithBalance(this.account, this.balance);
}
