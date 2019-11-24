import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/ApiConsumer.dart';
import 'package:ercoin_wallet/utils/SharedPreferencesUtil.dart';
import 'package:ercoin_wallet/utils/TransactionEncoder.dart';
import 'package:ercoin_wallet/view/home/HomeScreen.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sodium/flutter_sodium.dart';

class SendTransactionScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => SendTransactionState();
}

class SendTransactionState extends State<SendTransactionScreen>
{
  final _transactionEncoder = TransactionEncoder();
  final _apiConsumer = ApiConsumer();
  final _sharedPreferencesUtil = SharedPreferencesUtil();
  final _accountRepository = AccountRepository();

  final _formKey = GlobalKey<FormState>();

  String _receiverAddress;
  int _transactionValue;
  String _transactionMessage;

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
                    decoration: InputDecoration(labelText: "Transaction address"),
                    validator:
                        (value) => _validateTextField(value, "Please enter transaction address"),
                    onSaved:
                        (value) => _receiverAddress = value
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Transaction coins"),
                    keyboardType: TextInputType.number,
                    validator:
                        (value) => _validateTextField(value, "Please enter transaction coins"),
                    onSaved:
                        (value) => _transactionValue = int.parse(value)
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Transaction title"),
                    validator:
                        (value) => _validateTextField(value, "Please enter transaction title"),
                    onSaved:
                        (value) => _transactionMessage = value
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                        child: Text("Send transaction"),
                        onPressed: () => processForm()
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
      var publicKey = await _sharedPreferencesUtil.getSharedPreference('activeAccountKey');
      var activeAccount = await _accountRepository.findByPublicKey(publicKey);

      var timestamp = (new DateTime.now().millisecondsSinceEpoch  / 1000).round();

      var timestampBytes = _transactionEncoder.encodeTimestamp(timestamp);
      var receiverAddressBytes = _transactionEncoder.encodeReceiverAddress(_receiverAddress);
      var transactionValueBytes = _transactionEncoder.encodeTransactionValue(_transactionValue);
      var messageLengthBytes = _transactionEncoder.encodeMessageLength(_transactionMessage.length);
      var senderAddressBytes = _transactionEncoder.encodeSenderAddress(publicKey);
      var messageBytes = _transactionEncoder.encodeMessage(_transactionMessage);

      List<int> transactionBytes = List.from([0]);
      transactionBytes.addAll(timestampBytes);
      transactionBytes.addAll(receiverAddressBytes);
      transactionBytes.addAll(transactionValueBytes);
      transactionBytes.addAll(messageLengthBytes);
      transactionBytes.addAll(messageBytes);
      transactionBytes.addAll([1]);
      transactionBytes.addAll(senderAddressBytes);

      Uint8List ed25519Signature = await CryptoSign.signBytes(Uint8List.fromList(transactionBytes), Uint8List.fromList(hex.decode(activeAccount.privateKey)));

      transactionBytes.addAll(ed25519Signature);

      var transactionHex = _transactionEncoder.convertTransactionBytesToHex(Uint8List.fromList(transactionBytes));

      prepareConfirmationAlert(transactionHex).show();
    }
  }

  Alert prepareConfirmationAlert(String transactionHex) {
    return Alert(
      context: context,
      type: AlertType.info,
      title: "Are you sure to send transaction ?",
      buttons: [
          DialogButton(
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () {
                _apiConsumer.makeTransaction(transactionHex);
                prepareInfoAlert().show();
              }
          ),
          DialogButton(
              child: Text(
                "No",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () => Navigator
                  .of(context)
                  .pop()
          )
        ]
    );
  }

  Alert prepareInfoAlert() {
    return Alert(
        context: context,
        type: AlertType.info,
        title: "Ercoin process transaction.",
        buttons: [
          DialogButton(
              child: Text(
                "ok",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () => Navigator
                  .of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen()))
          )
        ]
    );
  }
}