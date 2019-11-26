import 'package:ercoin_wallet/interactor/add_account/add_account_interactor.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/configure_account_name/configure_account_name_route.dart';
import 'package:flutter/material.dart';

class AddAccountRoute extends StatefulWidget {
  final WidgetBuilder afterAdded;

  const AddAccountRoute({@required this.afterAdded});

  @override
  _AddAccountRouteState createState() => _AddAccountRouteState(afterAdded);
}

class _AddAccountRouteState extends State<AddAccountRoute> {
  final WidgetBuilder afterAdded;

  final _interactor = AddAccountInteractor(); // TODO(DI)
  bool _isLoading = false;

  _AddAccountRouteState(this.afterAdded);

  @override
  Widget build(BuildContext context) =>
      Scaffold(
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
        )
      );

  Widget _createAccountBtn() =>
      ExpandedRow(
        child: RaisedButton(
          child: const Text("Create new account"),
          onPressed: () => _createAccount(),
        ),
      );

  Widget _importAccountBtn() =>
      ExpandedRow(
        child: RaisedButton(
          child: const Text("Import account from backup"),
          onPressed: () => throw Exception(),
        ),
      );

  _createAccount() async {
    setState(() => _isLoading = true);
    final keyPair = await _interactor.generateKeyPair();
    moveTo(context, (_) => ConfigureAccountNameRoute(afterAdded: afterAdded, keyPair: keyPair));
  }
}
