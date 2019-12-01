import 'package:ercoin_wallet/interactor/address_list/AddressListInteractor.dart';
import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/utils/view/address_detail_widget.dart';
import 'package:ercoin_wallet/utils/view/address_list.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressListPage extends StatelessWidget {
  final _interactor = AddressListInteractor(); //TODO(DI)

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("Addresses"),
    ),
    body: FutureBuilderWithProgress(
      future: _interactor.obtainAddresses(),
      builder: (List<Address> addresses) => AddressList(addresses, (address) => _onAddressPressed(context, address))
    )
  );

  _onAddressPressed(BuildContext ctx, Address address) => showDialog(
      context: ctx,
      builder: (ctx) => _prepareAlertDialog(ctx, address)
  );

  AlertDialog _prepareAlertDialog(BuildContext ctx, Address address) => AlertDialog(
      title: Center(child: Text("Address detail")),
      content: AddressDetailWidget(address)
  );
}
