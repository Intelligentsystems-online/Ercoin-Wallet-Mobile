import 'dart:convert';

import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/utils/ApiConsumer.dart';
import 'package:ercoin_wallet/utils/BalanceAccountUtil.dart';
import 'package:ercoin_wallet/utils/SharedPreferencesUtil.dart';
import 'package:ercoin_wallet/view/home/HomeScreen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountFactory
{
  final _sharedPreferencesUtil = SharedPreferencesUtil();
  final _apiConsumer = ApiConsumer();
  final _balanceAccountUtil = BalanceAccountUtil();

  ListView prepareListComponent(BuildContext context, AsyncSnapshot<List<Account>> snapshot) => ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) =>  _prepareRowComponent(context, snapshot.data[index])
  );

  Widget _prepareRowComponent(BuildContext context, Account account) {
    return Container(
      child: FutureBuilder<String> (
        future: _apiConsumer.fetchAccountDataBase64For(account.publicKey),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
            default:
              if(snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return snapshot.data != null ? _prepareCardFor(context, account, prepareAccountBalance(snapshot.data)) : _prepareCardFor(context, account, 0);
          }
        }
      )
    );
  }

  int prepareAccountBalance(String accountDataBase64) =>
      accountDataBase64 == "" ? 0 : _balanceAccountUtil.obtainBalanceValue(base64.decode(accountDataBase64));

  Widget _prepareCardFor(BuildContext context, Account account, int accountBalance) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget> [
            Row(
              children: <Widget>[
                _prepareActiveAccountSign(account.publicKey),
                Padding(padding: EdgeInsets.only(right: 10.0)),
                //TODO Make API call for account balance.
                Text(account.accountName + ": " + accountBalance.toString(), style: TextStyle(fontSize: 18.0)),
                Padding(padding: EdgeInsets.only(right: 20.0)),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: RaisedButton(
                      child: Text("Activate account"),
                      onPressed: () {
                        _sharedPreferencesUtil.setSharedPreference('activeAccountKey', account.publicKey);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(right: 10.0)),
            SizedBox(
              width: double.infinity,
              child: Text("Public key: " + account.publicKey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _prepareActiveAccountSign(String accountKey) {
    return Container(
      child: FutureBuilder<String> (
        future: _sharedPreferencesUtil.getSharedPreference('activeAccountKey'),
        builder: (context, snapshot) => snapshot.hasData ? _prepareSuitableComponent(accountKey, snapshot.data) : Container(),
      )
    );
  }

  Widget _prepareSuitableComponent(String accountKey, String activeAccountKey) {
    if(accountKey == activeAccountKey)
      return CircleAvatar(child: Text("A"));
    else
      return Container();
  }
}
