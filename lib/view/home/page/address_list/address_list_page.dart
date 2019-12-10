import 'package:ercoin_wallet/interactor/address_list/AddressListInteractor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/utils/view/address_details_widget.dart';
import 'package:ercoin_wallet/utils/view/address_list.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/enter_address/enter_address_route.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class AddressListPage extends StatelessWidget {
  final _interactor = mainInjector.getDependency<AddressListInteractor>();

  @override
  Widget build(BuildContext ctx) => TopAndBottomContainer(
    top: _addressListBuilder(ctx),
    bottom: _addAddressBtn(ctx),
    bottomAlignment: FractionalOffset.bottomRight,
  );

  Widget _addressListBuilder(BuildContext ctx) => FutureBuilderWithProgress(
        future: _interactor.obtainAddresses(),
        builder: (List<Address> addresses) => AddressList(
          addresses: addresses,
          onAddressPressed: (ctx, address) => _onAddressPressed(ctx, address),
        ),
      );

  _onAddressPressed(BuildContext ctx, Address address) =>
      showDialog(context: ctx, builder: (ctx) => _prepareAlertDialog(ctx, address));

  Widget _prepareAlertDialog(BuildContext ctx, Address address) =>
      AlertDialog(title: Center(child: Text("Address detail")), content: AddressDetailsWidget(address));

  Widget _addAddressBtn(BuildContext ctx) => RawMaterialButton(
    shape: CircleBorder(),
    padding: standardPadding,
    fillColor: Colors.white,
    child: Icon(Icons.add, color: Colors.blue, size: 35.0),
    onPressed: () => _navigateToAddAddress(ctx),
  );

  _navigateToAddAddress(BuildContext ctx) => pushRoute(
    Navigator.of(ctx),
        () => EnterAddressRoute(
          isNameOptional: false,
          onProceed: (ctx, address, name) {
            _interactor.addAddress(address, name);
            resetRoute(Navigator.of(ctx), () => HomeRoute());
      },
    ),
  );
}
