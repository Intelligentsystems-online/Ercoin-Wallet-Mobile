import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/local_account/local_account_activation_details.dart';
import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/view/account_details/account_details_route.dart';

import 'package:flutter/material.dart';

import 'expanded_row.dart';

class AccountList extends StatelessWidget {
  final List<LocalAccountActivationDetails> list;
  final Function(LocalAccount) afterBackFromAccountDetails;
  final Function(LocalAccount) onActivate;

  const AccountList({this.list, this.afterBackFromAccountDetails, this.onActivate});

  @override
  Widget build(BuildContext ctx) => ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: list.length,
      itemBuilder: (context, index) => _accountBox(ctx, list[index]));

  Widget _accountBox(BuildContext ctx, LocalAccountActivationDetails details) => GestureDetector(
        onTap: () => _onAccountPressed(ctx, details.details.localAccount),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            title: Text(details.details.localAccount.namedAddress.name),
            subtitle: Text("${details.details.balance.ercoinFixed} ERN"),
            trailing: details.isActive ? _activeBadge() : _activateBtn(details.details.localAccount),
          ),
        ),
      );

  _activeBadge() => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const Icon(Icons.check, color: Colors.green),
      const SizedBox(width: 8.0),
      const Text("Active", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
    ],
  );

  _activateBtn(LocalAccount account) => OutlineButton(
    child: const Text("Activate"),
    onPressed: () => onActivate(account),
  );

  _onAccountPressed(BuildContext ctx, LocalAccount account) async {
    await pushRoute(Navigator.of(ctx), () => AccountDetailsRoute(account: account));
    afterBackFromAccountDetails(account);
  }
}
