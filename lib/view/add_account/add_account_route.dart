import 'package:ercoin_wallet/interactor/add_account/add_account_interactor.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/add_account/import_account/import_account_route.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import 'configure_account_name/configure_account_name_route.dart';

class AddAccountRoute extends StatefulWidget {
  final Function(BuildContext) onAdded;

  const AddAccountRoute({@required this.onAdded});

  @override
  _AddAccountRouteState createState() => _AddAccountRouteState(onAdded);
}

class _AddAccountRouteState extends State<AddAccountRoute> {
  final Function(BuildContext) onAdded;

  AddAccountInteractor _interactor; // TODO(DI)
  bool _isLoading = false;

  _AddAccountRouteState(this.onAdded) {
    Injector injector = Injector.appInstance;
    _interactor = injector.getDependency<AddAccountInteractor>();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text("Add account"),
      ),
      body: ProgressOverlayContainer(
        overlayEnabled: _isLoading,
        child: Container(
          padding: standardPadding,
          child: Column(
            children: <Widget>[_createAccountBtn(), _importAccountBtn()],
          ),
        ),
      ));

  Widget _createAccountBtn() => ExpandedRow(
        child: RaisedButton(
          child: const Text("Create new account"),
          onPressed: () => _createAccount(),
        ),
      );

  Widget _importAccountBtn() => ExpandedRow(
        child: RaisedButton(
          child: const Text("Import account from backup"),
          onPressed: () => pushRoute(Navigator.of(context), () => ImportAccountRoute(onAdded: onAdded)),
        ),
      );

  _createAccount() async {
    setState(() => _isLoading = true);
    final keys = await _interactor.generateAccountKeys();
    pushRoute(Navigator.of(context), () => ConfigureAccountNameRoute(onAdded: onAdded, keys: keys));
  }
}
