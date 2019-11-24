import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/model/TransactionFactory.dart';
import 'package:ercoin_wallet/view/home/HomeScreen.dart';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ComponentFactory
{
  final _transactionFactory = TransactionFactory();

  ListView prepareListComponent(BuildContext context, AsyncSnapshot<List<String>> snapshot) => ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) =>  _prepareRowComponentFor(context, snapshot.data[index])
  );

  Widget _prepareRowComponentFor(BuildContext context, String transactionBase64) {
    var transaction = _transactionFactory.createFromBase64(transactionBase64);
    return GestureDetector(
      onTap: () => showDialog(context: context, builder: (context) => prepareAlertDialog(context, transaction)),//prepareAlert(context, transaction).show(),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text("Receiver address: " + transaction.receiverAddress, style: TextStyle(fontSize: 18.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Builder bottomNavigationBarComponent() => Builder(builder: (context) => Container(
      padding:
        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: _transactionNavigationButton(context)
      )
  ));

  RaisedButton _transactionNavigationButton(BuildContext context) => RaisedButton(
      child: Text("Back to home"),
      onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));}
  );

  Alert prepareAlert(BuildContext context, Transaction transaction) {
    return Alert(
        context: context,
        type: AlertType.none,
        title: "Transaction detail:",
        desc: "Receiver: " +  transaction.receiverAddress + "\nCoins" + transaction.coins.toString()
    );
  }

  AlertDialog prepareAlertDialog(BuildContext context, Transaction transaction) {
    return AlertDialog(
      title: Center(child: Text("Transaction detail")),
      content: Column(
        children: <Widget>[
          Text("Receiver: " + transaction.receiverAddress),
          Text("Sender: " + transaction.senderAddress),
          Text("Coins: " + transaction.coins.toString()),
          Text("Message: " + transaction.message),
          Text("Timestamp: " + transaction.timestamp.toString()),
          FlatButton(
              child: Text("Close", style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
              onPressed: () => Navigator.of(context).pop()
          )
        ],
      )
    );
  }
}