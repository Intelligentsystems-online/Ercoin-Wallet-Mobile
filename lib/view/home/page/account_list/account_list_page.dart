import 'package:ercoin_wallet/interactor/account_list/account_list_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/account_info.dart';
import 'package:ercoin_wallet/utils/view/account_details_widget.dart';
import 'package:ercoin_wallet/utils/view/account_list.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/searchable_list.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/add_account/add_account_route.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  List<AccountInfo> _accountsInfo;
  String _activeAccountPk;

  final _interactor = mainInjector.getDependency<AccountListInteractor>();

  @override
  void initState() {
    _loadAccountsInfo();
    _loadActivePublicKey();
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) => TopAndBottomContainer(
    top: _accountListBuilder(ctx),
    bottom: _addAccountBtn(ctx),
    bottomAlignment: FractionalOffset.bottomRight,
  );

  Widget _accountListBuilder(BuildContext ctx) => ProgressOverlayContainer(
    overlayEnabled: _accountsInfo == null || _activeAccountPk == null,
    child: SearchableList(
      onSearchChanged: (value) => _onSearchChanged(value),
      listWidget: AccountList(_obtainFilteredList(), _activeAccountPk, (ctx, account) => _onAccountPressed(ctx, account))
    )
  );

  List<AccountInfo> _obtainFilteredList() => _accountsInfo == null ? [] : _accountsInfo;

  _onAccountPressed(BuildContext ctx, AccountInfo account) => showDialog(
      context: ctx,
      builder: (ctx) => _prepareAlertDialog(ctx, account)
  );

  _onSearchChanged(String value) {
    if(_accountsInfo != null) {
      value.isEmpty ? _loadAccountsInfo() : _loadFilteredAccountsInfo(value);
    }
  }

  AlertDialog _prepareAlertDialog(BuildContext ctx, AccountInfo account) => AlertDialog(
      title: Center(child: Text("Account detail")),
      content: AccountDetailsWidget(account, (ctx, publicKey) => _onActivate(ctx, publicKey))
  );

  _onActivate(BuildContext ctx, String publicKey) {
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

  _loadFilteredAccountsInfo(String name) async {
    final accounts = await _interactor.obtainAccountsInfoByName(name);
    setState(() => _accountsInfo = accounts);
  }

  _loadAccountsInfo() async {
    final accounts = await _interactor.obtainAccountsWithBalance();
    setState(() => _accountsInfo = accounts);
  }

  _loadActivePublicKey() async {
    final activePk = await _interactor.obtainActiveAccountPk();
    setState(() => _activeAccountPk = activePk);
  }
}