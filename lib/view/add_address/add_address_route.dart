import 'package:ercoin_wallet/interactor/add_address/AddAddressInteractor.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/values.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddAddressRoute extends StatefulWidget {
  final Function(BuildContext, String) onProceed;
  final bool checkboxEnable;

  const AddAddressRoute({@required this.onProceed, @required this.checkboxEnable});

  @override
  State<StatefulWidget> createState() => _AddAddressState(onProceed, checkboxEnable);
}

class _AddAddressState extends State<AddAddressRoute> {
  final Function(BuildContext, String) onProceed;
  final bool checkboxEnable;

  String _publicKey;
  String _addressName;
  bool _shouldSave = false;

  final _formKey = GlobalKey<FormState>();
  final _interactor = AddAddressInteractor(); //TODO(DI)

  _AddAddressState(this.onProceed, this.checkboxEnable);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Address configure"),
    ),
    body: Container(
      padding: standardPadding,
      child: checkboxEnable ? _withCheckboxView() : _withoutCheckboxView()
    ),
  );

  Widget _withCheckboxView() => Stack(
    children: <Widget>[
      Align(
        alignment: FractionalOffset.topCenter,
        child: Form(
          key: _formKey,
          child: Column(
              children: <Widget>[
                _publicKeyInput(),
                _shouldSave ? _addressNameInput() : Container(),
                _saveCheckboxRow(),
              ]
          ),
        ),
      ),
      Align(alignment: FractionalOffset.bottomCenter, child: _proceedBtn())
    ],
  );

  Widget _withoutCheckboxView() => Stack(
    children: <Widget>[
      Align(
        alignment: FractionalOffset.topCenter,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[_publicKeyInput(), _addressNameInput()],
          ),
        ),
      ),
      Align(alignment: FractionalOffset.bottomCenter, child: _proceedBtn())
    ],
  );

  Widget _saveCheckboxRow() => Row(
    children: <Widget>[
      Checkbox(
        value: _shouldSave,
        onChanged: (isChecked) => setState(() => _shouldSave = isChecked),
      ),
      const Expanded(
        child: const Text("Add to address book")
      )
    ],
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
      onSaved: (value) => setState(() => _addressName = value),
    ),
  );

  Widget _proceedBtn() => ExpandedRow(
    child: RaisedButton(
        child: const Text("Proceed"),
        onPressed: () => _onProceed()),
  );

  void _onProceed() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if(checkboxEnable == false || (checkboxEnable && _shouldSave))
        _interactor.saveAddress(_publicKey, _addressName);

      onProceed(context, _publicKey);
    }
  }
}