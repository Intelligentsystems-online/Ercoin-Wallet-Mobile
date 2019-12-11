import 'package:ercoin_wallet/interactor/address_book/address_book_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/repository/addressBook/AddressBookEntry.dart';
import 'package:ercoin_wallet/utils/view/address_book_entry_details_widget.dart';
import 'package:ercoin_wallet/utils/view/address_book_entry_list.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/enter_address_entry/enter_address_book_route.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class AddressBookPage extends StatelessWidget {
  final _interactor = mainInjector.getDependency<AddressBookInteractor>();

  @override
  Widget build(BuildContext ctx) => TopAndBottomContainer(
    top: _addressListBuilder(ctx),
    bottom: _addAddressBtn(ctx),
    bottomAlignment: FractionalOffset.bottomRight,
  );

  Widget _addressListBuilder(BuildContext ctx) => FutureBuilderWithProgress(
        future: _interactor.obtainAddressBookEntries(),
        builder: (List<AddressBookEntry> addressBookEntries) => AddressBookEntryList(
          addresseBookEntries: addressBookEntries,
          onAddressPressed: (ctx, address) => _onAddressPressed(ctx, address),
        ),
      );

  _onAddressPressed(BuildContext ctx, AddressBookEntry address) =>
      showDialog(context: ctx, builder: (ctx) => _prepareAlertDialog(ctx, address));

  Widget _prepareAlertDialog(BuildContext ctx, AddressBookEntry address) =>
      AlertDialog(title: Center(child: Text("Address detail")), content: AddressBookEntryDetailsWidget(address));

  Widget _addAddressBtn(BuildContext ctx) => RawMaterialButton(
    shape: CircleBorder(),
    padding: standardPadding,
    fillColor: Colors.white,
    child: Icon(Icons.add, color: Colors.blue, size: 35.0),
    onPressed: () => _navigateToAddAddress(ctx),
  );

  _navigateToAddAddress(BuildContext ctx) => pushRoute(
    Navigator.of(ctx),
        () => EnterAddressBookRoute(
          isNameOptional: false,
          onProceed: (ctx, address, name) {
            _interactor.addAddressBookEntry(address, name);
            resetRoute(Navigator.of(ctx), () => HomeRoute());
      },
    ),
  );
}