import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/view/account/AccountFactory.dart';
import 'package:ercoin_wallet/view/initial/InitialScreen.dart';

import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget
{
  final accountRepository = new AccountRepository();
  final componentFactory = new AccountFactory();

  @override
  Widget build(BuildContext context)
  {
    return Material(
      child: Scaffold(
          appBar: AppBar(title: Text("Ercoin wallet")),
          body: Container(
            child: FutureBuilder<List<Account>> (
              future: accountRepository.findAll(),
              builder: (context, snapshot) => snapshot.hasData ? componentFactory.prepareListComponent(context, snapshot) : Center(child: CircularProgressIndicator()),
            ),
          ),
        bottomNavigationBar: SizedBox(
            width: double.infinity,
            child: RaisedButton(
                child: Text("Create new account"),
                onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => InitialScreen()));}
            )
        ),
      ),
    );
  }
}
