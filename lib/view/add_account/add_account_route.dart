import 'package:ercoin_wallet/interactor/add_account/add_account_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/add_account/import_account/import_account_route.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:ercoin_wallet/view/registration_info/registration_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'configure_account_name/configure_account_name_route.dart';

class AddAccountRoute extends StatefulWidget {
  @override
  _AddAccountRouteState createState() => _AddAccountRouteState();
}

class _AddAccountRouteState extends State<AddAccountRoute> {
  final _interactor = mainInjector.getDependency<AddAccountInteractor>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext ctx) => Scaffold(
      appBar: AppBar(
        title: const Text("Add account"),
      ),
      body: ProgressOverlayContainer(
        overlayEnabled: _isLoading,
        child: TopAndBottomContainer(
          top: Text("You can either create a new account or import an existing account. In the latter it is possible to load account address and private key from previously exported file or enter them manually."),
          bottom: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _importAccountBtn(ctx),
              _createAccountBtn(),
            ],
          ),
        ),
      ));

  Widget _importAccountBtn(BuildContext ctx) => OutlineButton(
      child: const Text("Import existing account"),
      borderSide: BorderSide(color: Theme.of(ctx).primaryColor),
      onPressed: () async => await _onImportAccountPressed(),
    );

  _onImportAccountPressed() async {
    final onProceed = await _onProceedAction();
    pushRoute(Navigator.of(context), () => ImportAccountRoute(onAdded: onProceed));
  }

  Widget _createAccountBtn() => RaisedButton(
          child: const Text("Create new account"),
          onPressed: () async => await _createAccount(),
        );

  _createAccount() async {
    setState(() => _isLoading = true);
    final keys = await _interactor.generateAccountKeys();
    setState(() => _isLoading = false);
    final onProceed = await _onProceedAction();
    pushRoute(Navigator.of(context), () => ConfigureAccountNameRoute(onAdded: onProceed, keys: keys));
  }

  Future<Function(BuildContext)> _onProceedAction() async {
    if(await _interactor.shouldDisplayRegistrationInfo()) {
      return (ctx) => resetRoute(Navigator.of(ctx), () => RegistrationInfoPage());
    } else {
      return (ctx) => resetRoute(Navigator.of(ctx), () => HomeRoute());
    }
  }
}
