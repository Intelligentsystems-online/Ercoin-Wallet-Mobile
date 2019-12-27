import 'package:ercoin_wallet/interactor/transfer/destination/select_transfer_destination_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/named_address.dart';

import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/named_address_list.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/searchable_list.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/view/transfer/destination/enter_transfer_destination_route.dart';
import 'package:ercoin_wallet/view/transfer/transfer_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectTransferDestinationRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SelectTransferDestinationRouteState();
}

class _SelectTransferDestinationRouteState extends State<SelectTransferDestinationRoute> {
  List<NamedAddress> _namedAddressList;

  final _interactor = mainInjector.getDependency<SelectTransferDestinationInteractor>();

  @override
  void initState() {
    _loadNamedAddressList();
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) => Scaffold(
        appBar: AppBar(
          title: const Text("Select address"),
        ),
        body: ProgressOverlayContainer(
          overlayEnabled: _namedAddressList == null,
          child: TopAndBottomContainer(
            top: SearchableList(
              onSearchChanged: (value) => _onSearchChanged(value),
              listWidget: NamedAddressList(
                namedAddressList: _namedAddressList == null ? [] : _namedAddressList,
                onAddressPressed: (ctx, address) => _selectDestination(ctx, address.address, address.name),
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
    if(_namedAddressList != null) {
      value.isEmpty ? _loadNamedAddressList() : _loadFilteredNamedAddressList(value);
    }
  }

  _loadFilteredNamedAddressList(String value) async {
    final filteredEntries = await _interactor.obtainNamedAddressListByNameContains(value);

    setState(() => _namedAddressList = filteredEntries);
  }

  _loadNamedAddressList() async {
    final obtainedEntries = await _interactor.obtainNamedAddressList();
    setState(() {
      _namedAddressList = obtainedEntries;
    });
  }

  _selectDestination(BuildContext ctx, Address address, [String name]) =>
      pushRoute(Navigator.of(ctx), () => TransferRoute(destinationAddress: address, destinationName: name));

  _newAddress(BuildContext ctx) => pushRoute(Navigator.of(ctx), () => EnterTransferDestinationRoute());
}