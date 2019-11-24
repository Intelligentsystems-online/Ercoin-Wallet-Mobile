import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/view/home/HomeScreen.dart';
import 'package:ercoin_wallet/view/initial/InitialScreen.dart';

import 'package:flutter/material.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget
{
  final AccountRepository accountRepository = new AccountRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: prepareStartComponent()
    );
  }

  Widget prepareStartComponent() => Scaffold(
      body: startScreenBuilder());

  FutureBuilder<Widget> startScreenBuilder() => FutureBuilder<Widget> (
      future: selectSuitableScreen(),
      builder: (BuildContext context, AsyncSnapshot<Widget> widgetSnapshot) {return prepareContentScreen(widgetSnapshot);}
    );

  Future<Widget> selectSuitableScreen() async {
    List<Account> accounts = await accountRepository.findAll();

    return accounts.isEmpty ? InitialScreen() : HomeScreen();
  }

  Widget prepareContentScreen(AsyncSnapshot<Widget> widgetSnapshot) =>
    widgetSnapshot.hasData ? widgetSnapshot.data : Center(child: CircularProgressIndicator());
}
