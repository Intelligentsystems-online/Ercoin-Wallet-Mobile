import 'package:ercoin_wallet/interactor/add_account/import_account/import_account_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/private_key.dart';
import 'package:ercoin_wallet/model/local_account/local_account_data.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/standard_text_form_field.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/add_account/configure_account_name/configure_account_name_route.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';

class ImportAccountRoute extends StatefulWidget {
  final Function(BuildContext) onAdded;

  const ImportAccountRoute({@required this.onAdded});

  @override
  _ImportAccountRouteState createState() => _ImportAccountRouteState(onAdded);
}

class _ImportAccountRouteState extends State<ImportAccountRoute> {
  final Function(BuildContext) onAdded;

  String _address;
  String _privKey;

  final _interactor = mainInjector.getDependency<ImportAccountInteractor>();

  String _addressValidationResult;

  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _privKeyController = TextEditingController();

  _ImportAccountRouteState(this.onAdded);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text("Import account")),
        body: TopAndBottomContainer(
            top: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                      "In order to import account you will need address and private key. You can load them from previously exported file or enter them by hand."),
                  const SizedBox(height: 16.0),
                  _addressInput(),
                  const SizedBox(height: 16.0),
                  _privKeyInput(),
                ],
              ),
            ),
            bottom: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Builder(builder: (ctx) => _importFromFileBtn(ctx)),
                _proceedBtn(),
              ],
            )),
      );

  Widget _addressInput() => StandardTextFormField(
        hintText: "Address",
        icon: const Icon(Icons.edit),
        controller: _addressController,
        validator: (value) => _addressValidationResult,
        onSaved: (value) => setState(() => _address = value),
      );

  Widget _privKeyInput() => StandardTextFormField(
        hintText: "Private key",
        icon: const Icon(Icons.edit),
        controller: _privKeyController,
        validator: (value) => _interactor.validatePrivateKey(value),
        onSaved: (value) => setState(() => _privKey = value),
      );

  Widget _importFromFileBtn(BuildContext ctx) => OutlineButton(
        borderSide: BorderSide(color: Theme.of(ctx).primaryColor),
        child: const Text("Import from file"),
        onPressed: () => _importFromFile(ctx),
      );

  Widget _proceedBtn() => RaisedButton(
        child: const Text("Proceed"),
        onPressed: () => _onProceedPressed(),
      );

  _onProceedPressed() async {
    _formKey.currentState.save();
    await _validatePublicKey();
    if (_formKey.currentState.validate()) {
      pushRoute(
        Navigator.of(context),
        () => ConfigureAccountNameRoute(
          keys: LocalAccountKeys(address: Address.ofBase58(_address), privateKey: PrivateKey.ofBase58(_privKey)),
          onAdded: onAdded,
        ),
      );
    }
  }

  _importFromFile(BuildContext ctx) async {
    final filePath = await FilePicker.getFilePath();
    if (filePath != null) {
      try {
        final keys = await _interactor.importFromFile(filePath);

        _addressController.text = keys.address.base58;
        _privKeyController.text = keys.privateKey.base58;
        _formKey.currentState.save();
        await _validatePublicKey();
        _formKey.currentState.validate();
      } on FormatException {
        showTextSnackBar(Scaffold.of(ctx), "Invalid file format. Make sure to use valid backup file.");
      }
    }
  }

  _validatePublicKey() async {
    final validationResult = await _interactor.validatePublicKey(_address);
    if (validationResult != null)
      setState(() => _addressValidationResult = validationResult);
    else
      setState(() => _addressValidationResult = null);
  }
}
