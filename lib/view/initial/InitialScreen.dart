import 'package:ercoin_wallet/view/generateAccount/GenerateAccountScreen.dart';
import 'package:ercoin_wallet/view/importAccount/ImportAccountScreen.dart';

import 'package:flutter/material.dart';

//TODO Change class name - it's not only initial screen. Also it's used when we'd like to create new account from HomeScreen view.
class InitialScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(title: Text("Ercoin wallet")),
            body: Container(
              padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RaisedButton(
                      child: Text("Import account"),
                      onPressed: () => Navigator
                          .of(context)
                          .push(MaterialPageRoute(builder: (context) => ImportAccountScreen()))
                  ),
                  RaisedButton(
                      child: Text("Register account"),
                      onPressed: () => Navigator
                          .of(context)
                          .push(MaterialPageRoute(builder: (context) => GenerateAccountScreen()))
                  ),
                ],
              ),
            )
        )
    );
  }
}