import 'package:ercoin_wallet/interactor/configure_account_name/configure_account_name_interactor.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/home/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

class ConfigureAccountNameRoute extends StatefulWidget {
  final WidgetBuilder afterAdded;
  final KeyPair keyPair;

  ConfigureAccountNameRoute({@required this.afterAdded, @required this.keyPair});

  @override
  _ConfigureAccountNameRouteState createState() => _ConfigureAccountNameRouteState(afterAdded, keyPair);
}

class _ConfigureAccountNameRouteState extends State<ConfigureAccountNameRoute> {
  final WidgetBuilder afterAdded;
  final KeyPair keyPair;

  final _interactor = ConfigureAccountNameInteractor(); // TODO(DI)
  final _formKey = GlobalKey<FormState>();

  String _accountName = "";
  bool _isLoading = false;

  _ConfigureAccountNameRouteState(this.afterAdded, this.keyPair);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Configure account name"),
    ),
    body: ProgressOverlayContainer(
      overlayEnabled: _isLoading,
      child: Container(
        padding: standardPadding,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: FractionalOffset.topLeft,
              child: _nameInput()
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: _proceedBtn(),
            )
          ],
        ),
      ),
    )
  );

  Widget _nameInput() => ExpandedRow(
    child: Form(
      key: _formKey,
      child: TextFormField(
        decoration: const InputDecoration(labelText: "Account name"),
        validator: (value) => value.isEmpty ? 'Enter account name' : null,
        onSaved: (value) => setState(() => _accountName = value),
      ),
    ),
  );

  Widget _proceedBtn() => ExpandedRow(
    child: RaisedButton(
      child: const Text("Proceed"),
      onPressed: () => _validateAndProceed(),
    ),
  );

  _validateAndProceed() async {
    final form = _formKey.currentState;
    if(form.validate()) {
      form.save();
      setState(() => _isLoading);
      await _interactor.addAccount(keyPair, _accountName);
      moveTo(context, (_) => HomeScreen()); // TODO(Backup)
    }
  }
}
