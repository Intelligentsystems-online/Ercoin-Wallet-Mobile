import 'package:ercoin_wallet/interactor/add_address/add_address_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:ercoin_wallet/view/partial/form/enter_address_form.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddAddressRoute extends StatelessWidget {
  final Address initialAddress;

  final _interactor = mainInjector.getDependency<AddAddressIntractor>();

  AddAddressRoute({this.initialAddress});

  @override
  Widget build(BuildContext ctx) => Scaffold(
        appBar: AppBar(title: const Text("Add new address")),
        body: EnterAddressForm(
          isNameOptional: false,
          initialAddress: initialAddress,
          onProceed: (_, address, name) async {
            await _interactor.addAddress(address, name);
            resetRoute(Navigator.of(ctx), () => HomeRoute(initialPageIndex: 2));
          },
        ),
      );
}
