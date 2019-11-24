import 'package:ercoin_wallet/utils/KeyGenerator.dart';
import 'package:ercoin_wallet/utils/SharedPreferencesUtil.dart';
import 'package:ercoin_wallet/view/home/HomeScreen.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';

import 'package:flutter_sodium/flutter_sodium.dart';

import 'package:random_string/random_string.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:convert/convert.dart';

class GenerateAccountScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => _GenerateAccountState();
}

class _GenerateAccountState extends State<GenerateAccountScreen>
{
  final  _accountRepository = AccountRepository();
  final _sharedPreferencesUtil = SharedPreferencesUtil();
  final _keyGenerator = KeyGenerator();

  final _formKey = GlobalKey<FormState>();

  String _accountName;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
            title: Text("Ercoin wallet"),
            centerTitle: true),
        body: Container(
          padding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Builder(
            builder: (context) => Form(
              key: _formKey,
              child: Column(
                children: <Widget> [
                  TextFormField(
                    decoration: InputDecoration(labelText: "Account name"),
                    validator:
                        (value) => _validateTextField(value, "Please enter account name"),
                    onSaved:
                        (value) => _accountName = value
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      child: Text("Register account"),
                      onPressed: () => processForm(),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }

  _validateTextField(String value, String warningMessage) => value.isEmpty ? warningMessage : null;

  processForm() async {
    final formData = _formKey.currentState;

    if(formData.validate()) {
      formData.save();
      _keyGenerator
          .generateKeyPair()
          .then((keyPair) => saveAccount(keyPair));
    }
  }

  saveAccount(KeyPair keyPair) {
    _accountRepository.createAccount(Account(hex.encode(keyPair.publicKey), hex.encode(keyPair.secretKey), _accountName));

    _sharedPreferencesUtil.setSharedPreference('activeAccountKey', hex.encode(keyPair.publicKey));

    Navigator
        .of(context)
        .push(MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}