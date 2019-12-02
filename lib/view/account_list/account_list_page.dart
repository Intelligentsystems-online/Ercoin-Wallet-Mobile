import 'package:ercoin_wallet/interactor/account_list/account_list_interactor.dart';
import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/utils/view/account_detail_widget.dart';
import 'package:ercoin_wallet/utils/view/account_list.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/add_account/add_account_route.dart';
import 'package:ercoin_wallet/view/home/HomeScreen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountListPage extends StatelessWidget {
  final _interactor = AccountListInteractor(); //TODO(DI)

  @override
  Widget build(BuildContext ctx) => Scaffold(
    appBar: AppBar(
      title: Text("Accounts"),
    ),
    body: Stack(
      children: <Widget>[
        Align(
          alignment: FractionalOffset.topCenter,
          child:  _accountListBuilder(ctx),
        ),
        Align(
          alignment: FractionalOffset.bottomRight,
          child: _addAccountBtn(ctx),
        )
      ],
    )
  );

  Widget _accountListBuilder(BuildContext ctx) => FutureBuilderWithProgress(
      future: _interactor.obtainAccountsWithBalance(),
      builder: (List<AccountWithBalance> accounts) => FutureBuilderWithProgress(
        future: _interactor.obtainActiveAccountPk(),
        builder: (String activeAccountPk) => AccountList(accounts, activeAccountPk, (account) => _onAccountPressed(ctx, account)),
      )
  );

  Widget _addAccountBtn(BuildContext ctx) => RawMaterialButton(
    shape: CircleBorder(),
    padding: standardPadding,
    fillColor: Colors.white,
    child: Icon(Icons.add, color: Colors.blue, size: 35.0),
    onPressed: () => _navigateToAddAccount(ctx),
  );

  _navigateToAddAccount(BuildContext ctx) => pushRoute(
      Navigator.of(ctx), () => AddAccountRoute(onAdded: (ctx) => resetRoute(Navigator.of(ctx), () => HomeScreen()))
  );

  _onAccountPressed(BuildContext ctx, AccountWithBalance account) => showDialog(
      context: ctx,
      builder: (ctx) => _prepareAlertDialog(ctx, account)
  );

  AlertDialog _prepareAlertDialog(BuildContext ctx, AccountWithBalance account) => AlertDialog(
      title: Center(child: Text("Account detail")),
      content: AccountDetailWidget(account, () => _onActivate(ctx, account))
  );

  void _onActivate(BuildContext ctx, AccountWithBalance account) => _interactor
      .activateAccount(account.account.publicKey)
      .then((_) => resetRoute(Navigator.of(ctx), () => HomeScreen()));
}