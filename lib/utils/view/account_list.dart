import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountList extends StatelessWidget {
  final List<LocalAccountDetails> localAccountDetailsList;
  final String activeAccountPk;
  final Function(BuildContext, LocalAccountDetails) onAccountPressed;

  const AccountList(this.localAccountDetailsList, this.activeAccountPk, this.onAccountPressed);

  @override
  Widget build(BuildContext ctx) => ListView.builder(
      itemCount: localAccountDetailsList.length,
      itemBuilder: (context, index) => _accountBox(ctx, localAccountDetailsList[index])
  );

  Widget _accountBox(BuildContext ctx, LocalAccountDetails localAccountDetails) => GestureDetector(
    onTap: () => onAccountPressed(ctx, localAccountDetails),
    child: Card(
        child: ListTile(
          title: _accountNameLabel(localAccountDetails.localAccount),
          subtitle: _accountBalanceLabel(localAccountDetails.balance),
          trailing: _activeAccountSign(localAccountDetails.localAccount.namedAddress.address)
        )
    )
  );

  Widget _accountNameLabel(LocalAccount account) => Text(account.namedAddress.name);

  Widget _accountBalanceLabel(CoinsAmount balance) =>
      Text(balance.ercoin.toString() + " ERN");

  Widget _activeAccountSign(Address address) =>
      (address.publicKey == activeAccountPk) ? Icon(Icons.check, color: Colors.green) : IgnorePointer();
}
