import 'dart:async';

import 'package:ercoin_wallet/interactor/transfer/destination/select_transfer_destination_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/ui/named_address_lists.dart';

import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/named_address_list.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/searchable_list.dart';
import 'package:ercoin_wallet/utils/view/stream_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/view/transfer/destination/enter_transfer_destination_route.dart';
import 'package:ercoin_wallet/view/transfer/transfer_route.dart';
import 'package:flutter/material.dart';

class SelectTransferDestinationRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SelectTransferDestinationRouteState();
}

class _SelectTransferDestinationRouteState extends State<SelectTransferDestinationRoute> {
  final _interactor = mainInjector.getDependency<SelectTransferDestinationInteractor>();
  final _listsStream = StreamController<NamedAddressLists>();

  @override
  initState() {
    super.initState();
    _loadLists();
  }

  @override
  void dispose() {
    _listsStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Select address"),
        ),
        body: TopAndBottomContainer(
          top: SearchableList(
            onSearchChanged: (value) async => await _loadLists(value),
            listWidget: StreamBuilderWithProgress(
              stream: _listsStream.stream,
              builder: (_, NamedAddressLists lists) => NamedAddressList(
                namedAddressList: lists.namedAddressList,
                localAccountList: lists.localAccountList,
                onAddressPressed: (ctx, address) => _selectDestination(ctx, address.address, address.name),
              ),
            ),
          ),
          bottom: ExpandedRaisedTextButton(
            text: "New address",
            onPressed: () => _newAddress(ctx),
          ),
        ),
      );

  _loadLists([String value]) async {
    _listsStream.add(await _interactor.obtainNamedAddressLists(value));
  }

  _selectDestination(BuildContext ctx, Address address, [String name]) =>
      pushRoute(Navigator.of(ctx), () => TransferRoute(destinationAddress: address, destinationName: name));

  _newAddress(BuildContext ctx) => pushRoute(Navigator.of(ctx), () => EnterTransferDestinationRoute());
}
