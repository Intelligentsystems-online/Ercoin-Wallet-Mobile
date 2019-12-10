import 'package:ercoin_wallet/interactor/transfer/select_destination/select_transfer_destination_interactor.dart';
import 'package:ercoin_wallet/utils/view/address_list.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/view/enter_address/enter_address_route.dart';
import 'package:ercoin_wallet/view/transfer/transfer_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class SelectTransferDestinationRoute extends StatelessWidget {
  SelectTransferDestinationInteractor _interactor;

  SelectTransferDestinationRoute() {
    Injector injector = Injector.appInstance;
    _interactor = injector.getDependency<SelectTransferDestinationInteractor>();
  }

  @override
  Widget build(BuildContext ctx) => Scaffold(
        appBar: AppBar(
          title: const Text("Select address"),
        ),
        body: FutureBuilderWithProgress(
          future: _interactor.obtainAddressList(),
          builder: (addresses) => TopAndBottomContainer(
            top: AddressList(
              addresses: addresses,
              onAddressPressed: (ctx, address) => _selectDestination(ctx, address.publicKey, address.accountName),
            ),
            bottom: ExpandedRaisedTextButton(
              text: "New address",
              onPressed: () => _newAddress(ctx),
            ),
          ),
        ),
      );

  _selectDestination(BuildContext ctx, String address, [String name]) =>
      pushRoute(Navigator.of(ctx), () => TransferRoute(destinationAddress: address, destinationName: name));

  _newAddress(BuildContext ctx) => pushRoute(
        Navigator.of(ctx),
        () => EnterAddressRoute(
          isNameOptional: true,
          onProceed: (ctx, address, name) {
            if (name != null) {
              _interactor.addAddress(address, name);
            }
            _selectDestination(ctx, address, name);
          },
        ),
      );
}
