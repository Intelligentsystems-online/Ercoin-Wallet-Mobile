import 'package:ercoin_wallet/interactor/account_list/account_list_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/account_info.dart';
import 'package:ercoin_wallet/utils/view/account_details_widget.dart';
import 'package:ercoin_wallet/utils/view/account_list.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/add_account/add_account_route.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class AccountListPage extends StatelessWidget {
  AccountListInteractor _interactor = mainInjector.getDependency<AccountListInteractor>();

  @override
  Widget build(BuildContext ctx) => TopAndBottomContainer(
    top: _accountListBuilder(ctx),
    bottom: _addAccountBtn(ctx),
    bottomAlignment: FractionalOffset.bottomRight,
  );

  Widget _accountListBuilder(BuildContext ctx) => FutureBuilderWithProgress(
      future: _interactor.obtainAccountsWithBalance(),
      builder: (List<AccountInfo> accounts) => FutureBuilderWithProgress(
        future: _interactor.obtainActiveAccountPk(),
        builder: (String activeAccountPk) => AccountList(accounts, activeAccountPk, (ctx, account) => _onAccountPressed(ctx, account)),
      )
  );

  void _onAccountPressed(BuildContext ctx, AccountInfo account) => showDialog(
      context: ctx,
      builder: (ctx) => _prepareAlertDialog(ctx, account)
  );

  AlertDialog _prepareAlertDialog(BuildContext ctx, AccountInfo account) => AlertDialog(
      title: Center(child: Text("Account detail")),
      content: AccountDetailsWidget(account, (ctx, publicKey) => _onActivate(ctx, publicKey))
  );

  void _onActivate(BuildContext ctx, String publicKey) {
    _interactor.activateAccount(publicKey);

    resetRoute(Navigator.of(ctx), () => HomeRoute());
  }

  Widget _addAccountBtn(BuildContext ctx) => RawMaterialButton(
    shape: CircleBorder(),
    padding: standardPadding,
    fillColor: Colors.white,
    child: Icon(Icons.add, color: Colors.blue, size: 35.0),
    onPressed: () => _navigateToAddAccount(ctx),
  );

  _navigateToAddAccount(BuildContext ctx) => pushRoute(
      Navigator.of(ctx), () => AddAccountRoute(onAdded: (ctx) => resetRoute(Navigator.of(ctx), () => HomeRoute()))
  );
}