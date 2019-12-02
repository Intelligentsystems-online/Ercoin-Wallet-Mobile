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
        child: Row(children: <Widget>[
          _activeAccountSign(accountWithBalance.account),
          _accountLabel(accountWithBalance.account),
          Text(accountWithBalance.balance.toString())
        ]
      )
    )
  );

  Widget _accountLabel(Account account) => Text(account.accountName);

  Widget _activeAccountSign(Account account) => (account.publicKey == activeAccountPk) ? CircleAvatar(child: Text("A")) : Container();
}
