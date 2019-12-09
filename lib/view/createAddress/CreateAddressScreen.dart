import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/repository/address/AddressRepository.dart';
import 'package:ercoin_wallet/view/address/AddressScreen.dart';

import 'package:random_string/random_string.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateAddressScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => CreateAddressState();
}

class CreateAddressState extends State<CreateAddressScreen>
{
  final _addressRepository = AddressRepository();

  final _formKey = GlobalKey<FormState>();

  String _accountName;
  String _publicKey;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text("Ercoin wallet")),
        body: Container(
          padding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Builder(
            builder: (context) => Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: "Account name"),
                    validator:
                        (value) => _validateTextField(value, "Please enter account name"),
                    onSaved:
                        (value) => _accountName = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Public key"),
                    validator:
                        (value) => _validateTextField(value, "Please enter public key"),
                    onSaved:
                        (value) => _publicKey = value,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        child: Text("Create address"),
                        onPressed: () => _processForm(),
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _validateTextField(String value, String warningMessage) => value.isEmpty ? warningMessage : null;

  void _processForm() {
    final formData = _formKey.currentState;

    if(formData.validate()) {
      formData.save();
      _addressRepository.createAddress(_publicKey, _accountName);

      Navigator
          .of(context)
          .push(MaterialPageRoute(builder: (context) => AddressScreen()));
    }
  }
}