import 'package:ercoin_wallet/utils/KeyGenerator.dart';
import 'package:ercoin_wallet/utils/expanded_row.dart';
import 'package:ercoin_wallet/utils/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddAccountRoute extends StatefulWidget {
  final WidgetBuilder afterAdded;

  const AddAccountRoute({@required this.afterAdded});
}

class _AddAccountRouteState extends State<AddAccountRoute> {
  final keyGenerator = KeyGenerator();
  final WidgetBuilder afterAdded;

  bool _isLoading = false;

  _AddAccountRouteState({@required this.afterAdded});

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
    final keyPair = await keyGenerator.generateKeyPair();
    move
  }
}
