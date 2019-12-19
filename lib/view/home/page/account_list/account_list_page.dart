import 'package:ercoin_wallet/interactor/account_list/account_list_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
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
  List<LocalAccountDetails> _localAccountDetailsList;
  String _activeAccountPk;

  final _interactor = mainInjector.getDependency<AccountListInteractor>();

  @override
  void initState() {
    _loadLocalAccountDetailsList();
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
    overlayEnabled: _localAccountDetailsList == null || _activeAccountPk == null,
    child: SearchableList(
      onSearchChanged: (value) => _onSearchChanged(value),
      listWidget: AccountList(_obtainFilteredList(), _activeAccountPk, (ctx, account) => _onAccountPressed(ctx, account))
    )
  );

  List<LocalAccountDetails> _obtainFilteredList() => _localAccountDetailsList == null ? [] : _localAccountDetailsList;

  _onAccountPressed(BuildContext ctx, LocalAccountDetails localAccountDetails) => showDialog(
      context: ctx,
      builder: (ctx) => _prepareAlertDialog(ctx, localAccountDetails)
  );

  _onSearchChanged(String value) {
    if(_localAccountDetailsList != null) {
      value.isEmpty ? _loadLocalAccountDetailsList() : _loadFilteredLocalAccountDetailsList(value);
    }
  }

  AlertDialog _prepareAlertDialog(BuildContext ctx, LocalAccountDetails localAccountDetails) => AlertDialog(
      title: Center(child: Text("Account detail")),
      content: AccountDetailsWidget(localAccountDetails, (ctx, publicKey) => _onActivate(ctx, publicKey))
  );

  _onActivate(BuildContext ctx, String publicKey) {
    _interactor.activateAccount(Address(publicKey: publicKey));

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

  _loadFilteredLocalAccountDetailsList(String value) async {
    final accounts = await _interactor.obtainAccountDetailsListByNameContains(value);
    setState(() => _localAccountDetailsList = accounts);
  }

  _loadLocalAccountDetailsList() async {
    final accounts = await _interactor.obtainAccountDetailsList();
    setState(() => _localAccountDetailsList = accounts);
  }

  _loadActivePublicKey() async {
    final activePk = await _interactor.obtainActiveAccountAddress();
    setState(() => _activeAccountPk = activePk.publicKey);
  }
}