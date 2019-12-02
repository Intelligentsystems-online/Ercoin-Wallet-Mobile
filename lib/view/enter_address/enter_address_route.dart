import 'package:ercoin_wallet/utils/view/checkbox_with_text.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/utils/view/values.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  bool _shouldSave = false;

  final _formKey = GlobalKey<FormState>();

  _EnterAddressState(this.onProceed, this.isNameOptional);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Address configure"),
    ),
    body: TopAndBottomContainer(
      top: Form(
        key: _formKey,
        child: Column(children: <Widget>[
            _publicKeyInput(),
            isNameOptional ? _checkboxWithText() : Container(),
            !isNameOptional || _shouldSave ? _addressNameInput() : Container(),
          ]
        )
      ),
        bottom: _proceedBtn(),
    ),
  );

  Widget _checkboxWithText() => CheckboxWithTextWidget(
      text: "Add to address book",
      value: _shouldSave,
      onChanged: (isChecked) => setState(() => _shouldSave = isChecked)
  );

  Widget _publicKeyInput() => ExpandedRow(
    child: TextFormField(
      decoration: const InputDecoration(labelText: 'Public key'),
      validator: (value) => value.isEmpty ? "Enter public key" : null,
      onSaved: (value) => setState(() => _publicKey = value),
    ),
  );

  Widget _addressNameInput() => ExpandedRow(
    child: TextFormField(
      decoration: const InputDecoration(labelText: 'Address name'),
      validator: (value) => value.isEmpty ? "Enter address name" : null,
      onSaved: (value) => setState(() => _name = value),
    ),
  );

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
}