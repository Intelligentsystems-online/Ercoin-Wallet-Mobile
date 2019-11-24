import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/repository/address/AddressRepository.dart';
import 'package:ercoin_wallet/view/address/AddressFactory.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressScreen extends StatelessWidget
{
  final _addressRepository = AddressRepository();
  final _componentFactory = AddressFactory();
  
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text("Ercoin wallet")),
        body: Container(
          child: FutureBuilder<List<Address>> (
            future: _addressRepository.findAll(),
            builder: (context, snapshot) => snapshot.hasData ? _componentFactory.prepareListComponent(context, snapshot) : Container()
          ),
        ),
        bottomNavigationBar: _componentFactory.bottomNavigationBarComponent()
      ),
    );
  }
}