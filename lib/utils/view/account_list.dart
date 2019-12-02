import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountList extends StatelessWidget {
  final List<AccountWithBalance> accountsWithBalance;
  final String activeAccountPk;
  final Function(AccountWithBalance) onAccountPressed;

  const AccountList(this.accountsWithBalance, this.activeAccountPk, this.onAccountPressed);

  @override
  Widget build(BuildContext context) => ListView.builder(
      itemCount: accountsWithBalance.length,
      itemBuilder: (context, index) => _accountBox(accountsWithBalance[index])
  );

  Widget _accountBox(AccountWithBalance accountWithBalance) => GestureDetector(
    onTap: () => onAccountPressed(accountWithBalance),
    child: Card(
        child: Row(children: <Widget>[
          (accountWithBalance.account.publicKey == activeAccountPk) ? _activeAccountSign(accountWithBalance.account) : Container(),
          _accountLabel(accountWithBalance.account),
          Text(accountWithBalance.balance.toString())
        ]
      )
    )
  );

  Widget _accountLabel(Account account) => Text(account.accountName);

  Widget _activeAccountSign(Account account) => (account.publicKey == activeAccountPk) ? CircleAvatar(child: Text("A")) : Container();
}
