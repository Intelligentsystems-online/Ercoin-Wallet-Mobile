import 'package:ercoin_wallet/interactor/add_account/configure_account_name/configure_account_name_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/local_account/local_account_data.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/standard_text_form_field.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/add_account/backup_prompt/backup_prompt_route.dart';
import 'package:flutter/material.dart';

class ConfigureAccountNameRoute extends StatefulWidget {
  final Function(BuildContext) onAdded;
  final LocalAccountKeys keys;

  ConfigureAccountNameRoute({@required this.onAdded, @required this.keys});

  @override
  _ConfigureAccountNameRouteState createState() => _ConfigureAccountNameRouteState(onAdded, keys);
}

class _ConfigureAccountNameRouteState extends State<ConfigureAccountNameRoute> {
  final Function(BuildContext) onAdded;
  final LocalAccountKeys keys;

  final _interactor = mainInjector.getDependency<ConfigureAccountNameInteractor>();
  final _formKey = GlobalKey<FormState>();

  String _accountName = "";
  bool _isLoading = false;

  _ConfigureAccountNameRouteState(this.onAdded, this.keys);

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
              Align(alignment: FractionalOffset.topLeft, child: _nameInput()),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: _proceedBtn(),
              )
            ],
          ),
        ),
      ));

  Widget _nameInput() => ExpandedRow(
        child: Form(
          key: _formKey,
          child: StandardTextFormField(
            hintText: "Account name",
            icon: const Icon(Icons.account_circle),
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
    if (form.validate()) {
      form.save();
      setState(() => _isLoading);
      final localAccount = await _interactor.createLocalAccount(keys, _accountName);
      resetRoute(Navigator.of(context), () => BackupPromptRoute(localAccount: localAccount, onAdded: onAdded));
    }
  }
}
