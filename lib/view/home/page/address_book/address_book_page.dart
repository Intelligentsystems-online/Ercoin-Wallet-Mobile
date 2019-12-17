import 'package:ercoin_wallet/interactor/address_book/address_book_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/repository/addressBook/AddressBookEntry.dart';
import 'package:ercoin_wallet/utils/view/address_book_entry_details_widget.dart';
import 'package:ercoin_wallet/utils/view/address_book_entry_list.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/searchable_list.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/enter_address/enter_address_route.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressBookPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  List<AddressBookEntry> _addressBookEntries;

  final _interactor = mainInjector.getDependency<AddressBookInteractor>();

  @override
  void initState() {
    _loadAddressBookEntries();
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) => TopAndBottomContainer(
    top: _addressListBuilder(ctx),
    bottom: _addAddressBtn(ctx),
    bottomAlignment: FractionalOffset.bottomRight,
  );

  Widget _addressListBuilder(BuildContext ctx) => ProgressOverlayContainer(
    overlayEnabled: _addressBookEntries == null,
    child: SearchableList(
      onSearchChanged: (value) => _onSearchChanged(value),
      listWidget: AddressBookEntryList(
          addresseBookEntries: _addressBookEntries == null ? [] : _addressBookEntries,
          onAddressPressed: (ctx, address) => _onAddressPressed(ctx, address)
      ),
    )
  );

  _onSearchChanged(String value) {
    if(_addressBookEntries != null) {
      value.isEmpty ? _loadAddressBookEntries() : _loadFilteredAddressBookEntries(value);
    }
  }

  _loadFilteredAddressBookEntries(String name) async {
    final filteredEntries = await _interactor.obtainAddressBookEntriesByName(name);
    setState(() => _addressBookEntries = filteredEntries);
  }

  _loadAddressBookEntries() async {
    final obtainedEntries = await _interactor.obtainAddressBookEntries();
    setState(() => _addressBookEntries = obtainedEntries);
  }

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
        () => EnterAddressRoute(
          isNameOptional: false,
          onProceed: (ctx, address, name) {
            _interactor.addAddressBookEntry(address, name);
            resetRoute(Navigator.of(ctx), () => HomeRoute());
      },
    ),
  );
}
