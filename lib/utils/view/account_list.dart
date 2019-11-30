import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountList extends StatelessWidget {
  final List<Account> accounts;
  final String activeAccountPk;
  final Function(Account) onAccountPressed;

  const AccountList({this.accounts, this.activeAccountPk, this.onAccountPressed});

  @override
  Widget build(BuildContext context) => ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (context, index) => _accountBox(accounts[index])
  );

  Widget _accountBox(Account account) => GestureDetector(
    onTap: onAccountPressed(account),
    child: Column(
      children: <Widget>[_activeAccountSign(account), _accountLabel(account)],
    )
  );

  Widget _accountLabel(Account account) => Text(account.accountName);

  Widget _activeAccountSign(Account account) => (account.publicKey == activeAccountPk) ? CircleAvatar(child: Text("A")) : Container();
}