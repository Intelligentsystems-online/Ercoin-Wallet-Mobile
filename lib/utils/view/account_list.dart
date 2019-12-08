import 'package:ercoin_wallet/model/account_info.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountList extends StatelessWidget {
  final List<AccountInfo> accountsWithBalance;
  final String activeAccountPk;
  final Function(BuildContext, AccountInfo) onAccountPressed;

  const AccountList(this.accountsWithBalance, this.activeAccountPk, this.onAccountPressed);

  @override
  Widget build(BuildContext ctx) => ListView.builder(
      itemCount: accountsWithBalance.length,
      itemBuilder: (context, index) => _accountBox(ctx, accountsWithBalance[index])
  );

  Widget _accountBox(BuildContext ctx, AccountInfo accountInfo) => GestureDetector(
    onTap: () => onAccountPressed(ctx, accountInfo),
    child: Card(
        child: Row(children: <Widget>[
          _activeAccountSign(accountInfo.account),
          _accountLabel(accountInfo.account),
          Text(accountInfo.balance.toString())
        ]
      )
    )
  );

  Widget _accountLabel(Account account) => Text(account.accountName);

  Widget _activeAccountSign(Account account) => (account.publicKey == activeAccountPk) ? CircleAvatar(child: Text("A")) : Container();
}
