import 'package:ercoin_wallet/interactor/address_list/AddressListInteractor.dart';
import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/utils/view/address_detail_widget.dart';
import 'package:ercoin_wallet/utils/view/address_list.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/createAddress/CreateAddressScreen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressListPage extends StatelessWidget {
  final _interactor = AddressListInteractor(); //TODO(DI)

  @override
  Widget build(BuildContext ctx) => Scaffold(
    appBar: AppBar(
      title: Text("Addresses"),
    ),
    body: Stack(
      children: <Widget>[
        Align(
          alignment: FractionalOffset.topCenter,
          child: _addressListBuilder(ctx)
        ),
        Align(
          alignment: FractionalOffset.bottomRight,
          child: _addAddressBtn(ctx)
        )
      ],
    )
  );

  Widget _addressListBuilder(BuildContext ctx) => FutureBuilderWithProgress(
      future: _interactor.obtainAddresses(),
      builder: (List<Address> addresses) => AddressList(addresses, (ctx, address) => _onAddressPressed(ctx, address))
  );

  void _onAddressPressed(BuildContext ctx, Address address) => showDialog(
      context: ctx,
      builder: (ctx) => _prepareAlertDialog(ctx, address)
  );

  AlertDialog _prepareAlertDialog(BuildContext ctx, Address address) => AlertDialog(
      title: Center(child: Text("Address detail")),
      content: AddressDetailWidget(address)
  );

  Widget _addAddressBtn(BuildContext ctx) => RawMaterialButton(
    shape: CircleBorder(),
    padding: standardPadding,
    fillColor: Colors.white,
    child: Icon(Icons.add, color: Colors.blue, size: 35.0),
    onPressed: () => _navigateToAddAddress(ctx),
  );

  _navigateToAddAddress(BuildContext ctx) => pushRoute(
      Navigator.of(ctx), () => CreateAddressScreen() //TODO change to add_address_route after merge.
  );
}
