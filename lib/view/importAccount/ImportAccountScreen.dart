import 'package:ercoin_wallet/utils/SharedPreferencesUtil.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';

import 'package:random_string/random_string.dart';

import 'package:flutter/material.dart';

class ImportAccountScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => _ImportAccountState();
}

class _ImportAccountState extends State<ImportAccountScreen>
{
  final  _accountRepository = AccountRepository();
  final _sharedPreferencesUtil = SharedPreferencesUtil();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _accountName;
  String _publicKey;
  String _privateKey;

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
              autovalidate: false,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: "Account name"),
                    validator: (value) =>
                        _validateTextField(value, "Please enter account name"),
                    onSaved:
                        (value) => _accountName = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Public key"),
                    validator: (value) =>
                        _validateTextField(value, "Please enter public key"),
                    onSaved:
                        (value) => _publicKey = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Private key"),
                    validator: (value) =>
                        _validateTextField(value, "Please enter private key"),
                    onSaved:
                        (value) => _privateKey = value,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      child: Text("Import"),
                      onPressed: () => processForm(),
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

  processForm() async {
    final formData = _formKey.currentState;

    if(formData.validate()) {
      formData.save();
      _sharedPreferencesUtil.setSharedPreference('activeAccountKey', _publicKey);
      _accountRepository.createAccount(_publicKey, _privateKey, _accountName);

      Navigator
          .of(context)
          .push(MaterialPageRoute(builder: (context) => HomeRoute()));
    }
  }
}