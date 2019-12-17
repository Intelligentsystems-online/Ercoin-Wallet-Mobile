import 'package:ercoin_wallet/interactor/enter_address_book_entry/enter_address_book_entry_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/utils/view/checkbox_with_text.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/standard_text_form_field.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class EnterAddressRoute extends StatefulWidget {
  final Function(BuildContext, String, String) onProceed;
  final bool isNameOptional;

  const EnterAddressRoute({@required this.onProceed, @required this.isNameOptional});

  @override
  State<StatefulWidget> createState() => _EnterAddressState(onProceed, isNameOptional);
}

class _EnterAddressState extends State<EnterAddressRoute> {
  final Function(BuildContext, String, String) onProceed;
  final bool isNameOptional;
  String _publicKey;
  String _name;
  bool _shouldSave;

  String _publicKeyValidationResult;

  final _interactor = mainInjector.getDependency<EnterAddressBookEntryInteractor>();

  final _formKey = GlobalKey<FormState>();
  final _publicKeyController = TextEditingController();

  _EnterAddressState(this.onProceed, this.isNameOptional) {
    isNameOptional ? _shouldSave = false : _shouldSave = true;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Address configure"),
        ),
        body: TopAndBottomContainer(
          top: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _publicKeyInput(),
                _scanBtn(),
                isNameOptional ? _checkboxWithText() : Container(),
                !isNameOptional || _shouldSave ? _addressNameInput() : Container(),
              ],
            ),
          ),
          bottom: _proceedBtn(),
        ),
      );

  Widget _checkboxWithText() => CheckboxWithTextWidget(
      text: "Add to address book",
      value: _shouldSave,
      onChanged: (isChecked) => setState(() => _shouldSave = isChecked));

  Widget _publicKeyInput() => ExpandedRow(
        child: StandardTextFormField(
          hintText: "Public key",
          icon: const Icon(Icons.vpn_key),
          controller: _publicKeyController,
          validator: (value) =>
              _shouldSave ? _publicKeyValidationResult : _interactor.validatePublicKeyFormat(value),
          onSaved: (value) => setState(() => _publicKey = value),
        ),
      );

  Widget _addressNameInput() => ExpandedRow(
        child: StandardTextFormField(
          hintText: 'Address book name',
          icon: const Icon(Icons.account_circle),
          validator: (value) => value.isEmpty ? "Enter address name" : null,
          onSaved: (value) => setState(() => _name = value),
        ),
      );

  Widget _scanBtn() => ExpandedRaisedTextButton(
        text: "Scan",
        onPressed: _onScan,
      );

  _onScan() async {
    _publicKeyController.text = await QRCodeReader().scan();
  }

  Widget _proceedBtn() => ExpandedRaisedTextButton(
        text: "Proceed",
        onPressed: _onProceed,
      );

  _onProceed() async {
    _formKey.currentState.save();
    if(_shouldSave)
      await _validatePublicKey();
    if (_formKey.currentState.validate())
      onProceed(context, _publicKey, _name);
  }

  _validatePublicKey() async {
    final validationResult = await _interactor.validatePublicKey(_publicKey);
    if(validationResult != null)
      setState(() => _publicKeyValidationResult = validationResult);
    else
      setState(() => _publicKeyValidationResult = null);
  }
}
