import 'package:ercoin_wallet/interactor/address_book/address_book_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/utils/view/named_address_list.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/searchable_list.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/add_address/add_address_route.dart';
import 'package:ercoin_wallet/view/address_details/address_details_route.dart';

import 'package:flutter/material.dart';

class AddressBookPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> with AutomaticKeepAliveClientMixin<AddressBookPage> {
  List<NamedAddress> _namedAddressList;

  final _interactor = mainInjector.getDependency<AddressBookInteractor>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _loadNamedAddressList();
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    super.build(ctx);
    return Container(
      padding: standardPadding.copyWith(bottom: 0),
      child: ProgressOverlayContainer(
        overlayEnabled: _namedAddressList == null,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _addressList()),
              _addAddressBtn(ctx)
            ]
        ),
      ),
    );
  }

  Widget _addressList() => SearchableList(
        onSearchChanged: (value) => _onSearchChanged(value),
        listWidget: NamedAddressList(
            namedAddressList: _namedAddressList == null ? [] : _namedAddressList,
            onAddressPressed: (ctx, address) => _onAddressPressed(ctx, address)
        ),
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
    final obtainedEntries = await _interactor.obtainNamedAddressList();//.obtainAddressBookEntries();
    setState(() => _namedAddressList = obtainedEntries);
  }

  _onAddressPressed(BuildContext ctx, NamedAddress namedAddress) =>
      pushRoute(Navigator.of(context), () => AddressDetailsRoute(address: namedAddress));

  Widget _addAddressBtn(BuildContext ctx) => RaisedButton.icon(
      icon: const Text("Create new address"),
      label: const Icon(Icons.add),
      onPressed: () => pushRoute(Navigator.of(ctx), () => AddAddressRoute())
  );
}
