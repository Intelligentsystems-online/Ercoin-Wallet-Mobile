import 'package:ercoin_wallet/interactor/transfer/destination/enter_transfer_destination_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/view/partial/form/enter_address_form.dart';
import 'package:ercoin_wallet/view/transfer/transfer_route.dart';

import 'package:flutter/material.dart';

class EnterTransferDestinationRoute extends StatelessWidget {
  
  final _interactor = mainInjector.getDependency<EnterTransferDestinationInteractor>();
  
  @override
  Widget build(BuildContext ctx) => Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AppBar(title: const Text("Enter new address")),
    body: EnterAddressForm(
      isNameOptional: true,
      onProceed: (_, address, name) async {
        if(name != null) {
          await _interactor.addAddress(address, name);
        }
        pushRoute(Navigator.of(ctx), () => TransferRoute(destinationAddress: address, destinationName: name));
      },
    )
  );
}
