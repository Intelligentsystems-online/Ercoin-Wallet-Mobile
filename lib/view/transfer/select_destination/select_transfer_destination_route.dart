import 'package:ercoin_wallet/interactor/transfer/select_destination/select_transfer_destination_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/repository/addressBook/AddressBookEntry.dart';
import 'package:ercoin_wallet/utils/view/address_book_entry_list.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/searchable_list.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/view/enter_address/enter_address_route.dart';
import 'package:ercoin_wallet/view/transfer/transfer_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectTransferDestinationRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SelectTransferDestinationRouteState();
}

class _SelectTransferDestinationRouteState extends State<SelectTransferDestinationRoute> {
  List<AddressBookEntry> _addressBookEntries;

  final _interactor = mainInjector.getDependency<SelectTransferDestinationInteractor>();

  @override
  void initState() {
    _loadAddressBookEntries();
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) => Scaffold(
        appBar: AppBar(
          title: const Text("Select address"),
        ),
        body: ProgressOverlayContainer(
          overlayEnabled: _addressBookEntries == null,
          child: TopAndBottomContainer(
            top: SearchableList(
              onSearchChanged: (value) => _onSearchChanged(value),
              listWidget: AddressBookEntryList(
                addresseBookEntries: _addressBookEntries == null ? [] : _addressBookEntries,
                onAddressPressed: (ctx, address) => _selectDestination(ctx, address.publicKey, address.name),
              ),
            ),
            bottom: ExpandedRaisedTextButton(
              text: "New address",
              onPressed: () => _newAddress(ctx),
            ),
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
    setState(() {
      _addressBookEntries = obtainedEntries;
    });
  }

  _selectDestination(BuildContext ctx, String address, [String name]) =>
      pushRoute(Navigator.of(ctx), () => TransferRoute(destinationAddress: address, destinationName: name));

  _newAddress(BuildContext ctx) => pushRoute(
        Navigator.of(ctx),
        () => EnterAddressRoute(
          isNameOptional: true,
          onProceed: (ctx, address, name) {
            if (name != null) {
              _interactor.addAddressBookEntry(address, name);
            }
            _selectDestination(ctx, address, name);
          },
        ),
      );
}
