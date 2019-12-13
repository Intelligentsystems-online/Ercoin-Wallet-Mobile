import 'package:ercoin_wallet/interactor/add_account/import_account/import_account_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/account_keys.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/utils/service/common/keys_validation_util.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/standard_text_form_field.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/add_account/configure_account_name/configure_account_name_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class ImportAccountRoute extends StatefulWidget {
  final Function(BuildContext) onAdded;

  const ImportAccountRoute({@required this.onAdded});

  @override
  _ImportAccountRouteState createState() => _ImportAccountRouteState(onAdded);
}

class _ImportAccountRouteState extends State<ImportAccountRoute> {
  final Function(BuildContext) onAdded;

  List<String> _accountKeys;
  String _pubKey;
  String _privKey;

  final _interactor = mainInjector.getDependency<ImportAccountInteractor>();
  final _keysValidationUtil = mainInjector.getDependency<KeysValidationUtil>();

  final _formKey = GlobalKey<FormState>();
  final _pubKeyController = TextEditingController();
  final _privKeyController = TextEditingController();

  _ImportAccountRouteState(this.onAdded);

  @override
  void initState() {
    _loadAccountKeys();
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) => Scaffold(
        appBar: AppBar(
          title: const Text("Import account"),
        ),
        body: Container(
          padding: standardPadding,
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: FractionalOffset.topLeft,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[_pubKeyInput(), _privKeyInput(), _importFromFileBtn(ctx)],
                    ),
                  )),
              Align(alignment: FractionalOffset.bottomCenter, child: _proceedBtn())
            ],
          ),
        ),
      );

  Widget _pubKeyInput() => ExpandedRow(
        child: StandardTextFormField(
          hintText: 'Public key',
          controller: _pubKeyController,
          validator: (value) => _keysValidationUtil.validatePublicKey(value, _accountKeys),
          onSaved: (value) => setState(() => _pubKey = value),
        ),
      );

  Widget _privKeyInput() => ExpandedRow(
        child: StandardTextFormField(
          hintText: 'Private key',
          icon: const Icon(Icons.vpn_key),
          controller: _privKeyController,
          validator: (value) => _keysValidationUtil.validatePrivateKey(value),
          onSaved: (value) => setState(() => _privKey = value),
        ),
      );

  Widget _importFromFileBtn(BuildContext ctx) => ExpandedRaisedTextButton(
        text: "Import from file",
        onPressed: () => _importFromFile(ctx),
      );

  Widget _proceedBtn() => ExpandedRaisedTextButton(
        text: "Proceed",
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            pushRoute(Navigator.of(context),
                () => ConfigureAccountNameRoute(keys: AccountKeys(_pubKey, _privKey), onAdded: onAdded));
          }
        },
      );

  _loadAccountKeys() async {
    final keys = await _interactor.obtainAccountKeys();
    setState(() => _accountKeys = keys);
  }

  _importFromFile(BuildContext ctx) async {
    final filePath = await FilePicker.getFilePath();
    if (filePath != null) {
      try {
        final keys = await _interactor.importFromFile(filePath);

        _pubKeyController.text = keys.publicKey;
        _privKeyController.text = keys.privateKey;
        _formKey.currentState.validate();
      }
      on FormatException {
        showDialog(context: ctx, builder: (ctx) =>  AlertDialog(
            content: const Text("Incorrect file.")
        ));
      }
    }
  }
}
