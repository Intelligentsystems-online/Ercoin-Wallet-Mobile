import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/view/createAddress/CreateAddressScreen.dart';
import 'package:ercoin_wallet/view/enter_address/enter_address_route.dart';
import 'package:ercoin_wallet/view/home/HomeScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddressFactory
{
  ListView prepareListComponent(BuildContext context, AsyncSnapshot<List<Address>> snapshot) => ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) =>  _prepareRowComponentFor(context, snapshot.data[index])
  );

  Widget _prepareRowComponentFor(BuildContext context, Address address) {
    return GestureDetector(
      onTap: () => prepareAlert(context, address).show(),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Text(address.accountName, style: TextStyle(fontSize: 18.0))
            ],
          ),
        ),
      ),
    );
  }

  Builder bottomNavigationBarComponent() => Builder(builder: (context) => Container(
      padding:
        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          _accountNavigationButton(context),
          Padding(padding: EdgeInsets.only(right: 10.0)),
          _transactionNavigationButton(context)
        ],
      )
  ));

  RaisedButton _accountNavigationButton(BuildContext context) => RaisedButton(
      child: Text("Create new address"),
      onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => EnterAddressRoute(
        onProceed: (ctx, publicKey, addressName) => {},
        isNameOptional: true,
      )));}
  );

  RaisedButton _transactionNavigationButton(BuildContext context) => RaisedButton(
      child: Text("Back to home"),
      onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));}
  );

  Alert prepareAlert(BuildContext context, Address address) {
    return Alert(
        context: context,
        type: AlertType.none,
        title: "Address public key",
        buttons: [
          DialogButton(
              child: Text(
                "Copy",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () => {
                Clipboard.setData(ClipboardData(text: address.publicKey)),
                Navigator.of(context).pop()}
          )
        ]
    );
  }
}