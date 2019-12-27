import 'package:ercoin_wallet/interactor/enter_address/enter_address_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/utils/view/checkbox_with_text.dart';
import 'package:ercoin_wallet/utils/view/standard_text_form_field.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class EnterAddressForm extends StatefulWidget {
  final Function(BuildContext, Address, String) onProceed;
  final bool isNameOptional;
  final Address initialAddress;

  const EnterAddressForm({
    @required this.onProceed,
    @required this.isNameOptional,
    this.initialAddress,
  });

  @override
  State<StatefulWidget> createState() => _EnterAddressState(onProceed, isNameOptional, initialAddress);
}

class _EnterAddressState extends State<EnterAddressForm> {
  final Function(BuildContext, Address, String) onProceed;
  final bool isNameOptional;
  String _publicKey;
  String _name;
  bool _shouldSave;

  String _publicKeyValidationResult;

  final _interactor = mainInjector.getDependency<EnterAddressFormInteractor>();

  final _formKey = GlobalKey<FormState>();
  final _publicKeyController = TextEditingController();

  _EnterAddressState(this.onProceed, this.isNameOptional, Address initialAddress) {
    _shouldSave = !isNameOptional;
    _publicKeyController.value = TextEditingValue(text: initialAddress?.base58 ?? "");
  }

  @override
  Widget build(BuildContext context) => TopAndBottomContainer(
        top: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _publicKeyInput(),
              const SizedBox(height: 8.0),
              if (!isNameOptional || _shouldSave) _addressNameInput(),
              const SizedBox(height: 8.0),
              if (isNameOptional) _enterNameCheckbox(),
            ],
          ),
        ),
        bottom: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[_scanBtn(), _proceedBtn()],
        ),
      );

  Widget _enterNameCheckbox() => CheckboxWithTextWidget(
      text: "Add to address book",
      value: _shouldSave,
      onChanged: (isChecked) => setState(() => _shouldSave = isChecked));

  Widget _publicKeyInput() => StandardTextFormField(
        hintText: "Address",
        icon: const Icon(Icons.vpn_key),
        controller: _publicKeyController,
        validator: (value) => _publicKeyValidationResult,
        onSaved: (value) => setState(() => _publicKey = value),
      );

  Widget _addressNameInput() => StandardTextFormField(
        hintText: "Name",
        icon: const Icon(Icons.account_circle),
        validator: (value) => value.isEmpty ? "Enter name" : null,
        onSaved: (value) => setState(() => _name = value),
      );

  Widget _scanBtn() => OutlineButton(
        child: const Text("Scan QR code"),
        onPressed: () async => _publicKeyController.text = await QRCodeReader().scan(),
      );

  Widget _proceedBtn() => RaisedButton(
        child: const Text("Proceed"),
        onPressed: _onProceed,
      );

  _onProceed() async {
    _formKey.currentState.save();
    await _validatePublicKey();
    if (_formKey.currentState.validate()) {
      onProceed(context, Address.ofBase58(_publicKey), _name);
    }
  }

  _validatePublicKey() async {
    final validationResult = await _interactor.validatePublicKey(_publicKey);
    if (validationResult != null)
      setState(() => _publicKeyValidationResult = validationResult);
    else
      setState(() => _publicKeyValidationResult = null);
  }
}
