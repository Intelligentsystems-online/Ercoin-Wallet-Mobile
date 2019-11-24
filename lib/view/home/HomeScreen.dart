import 'package:ercoin_wallet/view/account/AccountScreen.dart';
import 'package:ercoin_wallet/view/address/AddressScreen.dart';
import 'package:ercoin_wallet/view/home/HomeFactory.dart';
import 'package:ercoin_wallet/view/initial/InitialScreen.dart';
import 'package:ercoin_wallet/view/sendTransaction/SendTransactionScreen.dart';
import 'package:ercoin_wallet/view/transaction/TransactionScreen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget
{
  final componentFactory = HomeFactory();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          appBar: AppBar(title: Text("Ercoin wallet")),
          body: Column(
            children: <Widget>[
              componentFactory.prepareActiveAccountContainer(),
              SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                      child: Text("Send"),
                      onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SendTransactionScreen()));}
                  )
              ),
              SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                      child: Text("Transactions"),
                      onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransactionScreen()));}
                  )
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                    child: Text("My accounts"),
                    onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountScreen()));}
                )
              ),
              SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                      child: Text("Address book"),
                      onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddressScreen()));}
                  )
              )
            ],
          ),
      ),
    );
  }

}