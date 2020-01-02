import 'package:ercoin_wallet/interactor/transfer_list/transfer_list_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:ercoin_wallet/model/transfer/transfer_direction.dart';
import 'package:ercoin_wallet/utils/view/refreshable_future_builder.dart';
import 'package:ercoin_wallet/utils/view/transfer_list.dart';

import 'package:flutter/material.dart';

class TransferListPage extends StatefulWidget {
  final Stream _stream;

  TransferListPage(this._stream);

  @override
  _TransferListPageState createState() => _TransferListPageState(_stream);
}

class _TransferListPageState extends State<TransferListPage> {
  TransferDirection _transferDirection;
  Stream _stream;

  final _interactor = mainInjector.getDependency<TransferListInteractor>();
  final _builderKey = GlobalKey<RefreshableFutureBuilderState>();

  _TransferListPageState(this._stream);

  @override
  void initState() {
    if(_stream != null && _builderKey.currentState != null) {
      _stream.listen((_) => _builderKey.currentState.update(isRefresh: true));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) => RefreshableFutureBuilder<List<Transfer>>(
    key: _builderKey,
    forceScrollable: false,
    futureBuilder: (isRefresh) async => await _interactor.obtainTransferList(_transferDirection, refresh: isRefresh),
    builder: (_, List<Transfer> transferList) => Column(
      children: <Widget>[
        _filterChips(),
        Expanded(child: TransferList(list: transferList)),
      ],
    ),
  );

  Widget _filterChips() => Row(
        children: <Widget>[
          const SizedBox(width: 8.0),
          const Text("Show only:"),
          const SizedBox(width: 8.0),
          _filterChip(text: "Inbound", direction: TransferDirection.IN),
          const SizedBox(width: 8.0),
          _filterChip(text: "Outgoing", direction: TransferDirection.OUT),
        ],
      );

  Widget _filterChip({TransferDirection direction, String text}) => FilterChip(
        backgroundColor: Colors.transparent,
        shape: StadiumBorder(side: BorderSide(color: Colors.black.withOpacity(0.1))),
        selectedColor: Colors.black.withOpacity(0.1),
        label: Text(text),
        selected: _transferDirection == direction,
        onSelected: (isSelected) {
          setState(() => _transferDirection = isSelected ? direction : null);
          _builderKey.currentState.update(isRefresh: false);
        },
      );
}
