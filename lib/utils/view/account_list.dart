import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountList extends StatelessWidget {
  final List<AccountWithBalance> accountsWithBalance;
  final String activeAccountPk;
  final Function(BuildContext, AccountWithBalance) onAccountPressed;

  const AccountList(this.accountsWithBalance, this.activeAccountPk, this.onAccountPressed);

  @override
  Widget build(BuildContext ctx) => ListView.builder(
      itemCount: accountsWithBalance.length,
      itemBuilder: (context, index) => _accountBox(ctx, accountsWithBalance[index])
  );

  Widget _accountBox(BuildContext ctx, AccountWithBalance accountWithBalance) => GestureDetector(
    onTap: () => onAccountPressed(ctx, accountWithBalance),
    child: Card(
        child: ListTile(
          title: _accountNameLabel(accountWithBalance.account),
          subtitle: _accountBalanceLabel(accountWithBalance),
          trailing: _activeAccountSign(accountWithBalance.account)
        )
    )
  );

  Widget _accountNameLabel(Account account) => Text(account.accountName);

  Widget _accountBalanceLabel(AccountWithBalance accountWithBalance) =>
      Text(accountWithBalance.balance.toString() + " ERC");

  Widget _activeAccountSign(Account account) =>
      (account.publicKey == activeAccountPk) ? Icon(Icons.check, color: Colors.blue) : IgnorePointer();
}
