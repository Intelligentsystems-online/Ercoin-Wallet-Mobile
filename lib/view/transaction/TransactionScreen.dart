import 'package:ercoin_wallet/utils/ApiConsumer.dart';
import 'package:ercoin_wallet/utils/SharedPreferencesUtil.dart';
import 'package:ercoin_wallet/view/transaction/ComponentFactory.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionScreen extends StatelessWidget
{
  final _componentFactory = ComponentFactory();
  final _apiConsumer = ApiConsumer();
  final _sharedPreferencesUtil = SharedPreferencesUtil();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          appBar: AppBar(title: Text("Ercoin wallet")),
          body: Container(
              child: FutureBuilder<String> (
                  future: _sharedPreferencesUtil.getSharedPreference('activeAccountKey'),
                  builder:
                      (context, snapshot) => snapshot.hasData ? transactionListContainer(snapshot.data) : Container(child: Text("Not found account"))
              )
          ),
          bottomNavigationBar: _componentFactory.bottomNavigationBarComponent()
      ),
    );
  }

  Container transactionListContainer(String accountKey) {
    return Container(
      child: FutureBuilder<List<String>> (
          future: _apiConsumer.fetchOutboundTransactionBase64ListFor(accountKey),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
              default:
                if(snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else
                  return _componentFactory.prepareListComponent(context, snapshot);
            }
          }
      )
    );
  }
}