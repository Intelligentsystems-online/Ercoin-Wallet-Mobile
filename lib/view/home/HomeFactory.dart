import 'dart:convert';

import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/ApiConsumer.dart';
import 'package:ercoin_wallet/utils/BalanceAccountUtil.dart';
import 'package:ercoin_wallet/utils/SharedPreferencesUtil.dart';

import 'package:flutter/material.dart';

class HomeFactory
{
  final _sharedPreferencesUtil = SharedPreferencesUtil();
  final _accountRepository = AccountRepository();
  final _apiConsumer = ApiConsumer();
  final _balanceAccountUtil = BalanceAccountUtil();

  //TODO Make refactor for two methods below
  Container prepareActiveAccountContainer() {
    return Container(
        child: FutureBuilder<String> (
          future: _sharedPreferencesUtil.getSharedPreference('activeAccountKey'),
          builder:
              (context, snapshot) => snapshot.hasData ? buildContainerFor(snapshot.data) : Container(child: Text("Not found account"))
        )
    );
  }

  Container buildContainerFor(String accountKey) {
    return Container(
        child: FutureBuilder<Account> (
            future: _accountRepository.findByPublicKey(accountKey),
            builder:
                (context, snapshot) => snapshot.hasData ? containerFor(accountKey) : Container(child: Text("Not fount account: " + accountKey))
        )
    );
  }

  Container containerFor(String accountKey) {
    return Container(
      child: FutureBuilder<String> (
        future: _apiConsumer.fetchAccountDataBase64For(accountKey),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
            default:
              if(snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return snapshot.data != null ? Text(prepareAccountBalance(snapshot.data).toString() + " coins on account : " + accountKey) : Text("0 coins on account : " + accountKey);
          }
        }
      )
    );
  }

  int prepareAccountBalance(String accountDataBase64) => _balanceAccountUtil.obtainBalanceValue(base64.decode(accountDataBase64));
}