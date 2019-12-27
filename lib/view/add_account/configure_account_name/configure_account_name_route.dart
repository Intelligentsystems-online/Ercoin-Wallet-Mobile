import 'package:ercoin_wallet/interactor/add_account/configure_account_name/configure_account_name_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/local_account/local_account_data.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/standard_text_form_field.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Configure account name"),
      ),
      body: ProgressOverlayContainer(
        overlayEnabled: _isLoading,
        child: TopAndBottomContainer(
          top: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text("Enter in-app name for this account. This name is visible only to you and can be different across different devices"),
              const SizedBox(height: 16.0),
              _nameInput(),
            ],
          ),
          bottom: ExpandedRow(child: _proceedBtn()),
        ),
      ));

  Widget _nameInput() => Form(
        key: _formKey,
        child: StandardTextFormField(
          hintText: "Name",
          icon: const Icon(Icons.edit),
          validator: (value) => value.isEmpty ? 'Enter name' : null,
          onSaved: (value) => setState(() => _accountName = value),
        ),
      );

  Widget _proceedBtn() => RaisedButton(
        child: const Text("Proceed"),
        onPressed: () => _validateAndProceed(),
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
