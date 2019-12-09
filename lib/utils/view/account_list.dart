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
        child: ListTile(
          title: _accountNameLabel(accountInfo.account),
          subtitle: _accountBalanceLabel(accountInfo),
          trailing: _activeAccountSign(accountInfo.account)
        )
    )
  );

  Widget _accountNameLabel(Account account) => Text(account.accountName);

  Widget _accountBalanceLabel(AccountInfo accountInfo) =>
      Text(accountInfo.balance.toString() + " ERC");

  Widget _activeAccountSign(Account account) =>
      (account.publicKey == activeAccountPk) ? Icon(Icons.check, color: Colors.blue) : IgnorePointer();
}
