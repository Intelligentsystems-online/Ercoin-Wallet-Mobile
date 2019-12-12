import 'package:ercoin_wallet/interactor/enter_address_entry/enter_address_entry_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/utils/service/common/keys_validation_util.dart';
import 'package:ercoin_wallet/utils/view/checkbox_with_text.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/standard_text_form_field.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class EnterAddressBookRoute extends StatefulWidget {
  final Function(BuildContext, String, String) onProceed;
  final bool isNameOptional;

  const EnterAddressBookRoute({@required this.onProceed, @required this.isNameOptional});

  @override
  State<StatefulWidget> createState() => _EnterAddressBookState(onProceed, isNameOptional);
}

class _EnterAddressBookState extends State<EnterAddressBookRoute> {
  final Function(BuildContext, String, String) onProceed;
  final bool isNameOptional;

  List<String> _addresses;
  String _publicKey;
  String _name;
  bool _shouldSave = false;

  final _interactor = mainInjector.getDependency<EnterAddressEntryInteractor>();
  final _keyValidationUtil = mainInjector.getDependency<KeysValidationUtil>();

  final _formKey = GlobalKey<FormState>();
  final _publicKeyController = TextEditingController();

  _EnterAddressBookState(this.onProceed, this.isNameOptional);

  @override
  void initState() {
    _loadAddresses();
    super.initState();
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
          validator: (value) => _keyValidationUtil.validatePublicKey(value, _addresses),
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

  _onProceed() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      onProceed(context, _publicKey, _name);
    }
  }

  _loadAddresses() async {
    final addresses = await _interactor.obtainAddresses();
    setState(() => _addresses = addresses);
  }
}
