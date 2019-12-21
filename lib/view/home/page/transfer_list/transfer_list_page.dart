import 'package:ercoin_wallet/interactor/transfer_list/transfer_list_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:ercoin_wallet/model/transfer/transfer_direction.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/transfer_details_widget.dart';
import 'package:ercoin_wallet/utils/view/transfer_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransferListPage extends StatefulWidget {
  @override
  _TransferListPageState createState() => _TransferListPageState();
}

class _TransferListPageState extends State<TransferListPage> {
  TransferDirection _transferDirection;
  List<Transfer> _allTransfers, _inboundTransfers, _outTransfers;

  final _interactor = mainInjector.getDependency<TransferListInteractor>();

  @override
  void initState() {
    _loadTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) => ProgressOverlayContainer(
        overlayEnabled: _allTransfers == null,
        child: Column(
          children: <Widget>[
            _filterChips(),
            Expanded(child: TransferList(list: _obtainFilteredTransferList())),
          ],
        ),
      );

  Widget _filterChips() => Row(
    children: <Widget>[
      const SizedBox(width: 8.0), const Text("Show only:"),
      const SizedBox(width: 8.0), _filterChip(text: "Inbound", direction: TransferDirection.IN),
      const SizedBox(width: 8.0), _filterChip(text: "Outgoing", direction: TransferDirection.OUT),
    ],
  );

  Widget _filterChip({TransferDirection direction, String text}) => FilterChip(
    backgroundColor: Colors.transparent,
    shape: StadiumBorder(side: BorderSide(color: Colors.black.withOpacity(0.1))),
    selectedColor: Colors.black.withOpacity(0.1),
    label: Text(text),
    selected: _transferDirection == direction,
    onSelected: (isSelected) => setState(() => _transferDirection = isSelected ? direction : null),
  );

  _loadTransactions() async {
    final transferLists = await _interactor.obtainTransferLists();

    setState(() {
      _allTransfers = transferLists[0];
      _inboundTransfers = transferLists[1];
      _outTransfers = transferLists[2];
    });
  }

  List<Transfer> _obtainFilteredTransferList() {
    if (_allTransfers == null) {
      return [];
    } else {
      switch (_transferDirection) {
        case TransferDirection.IN:
          return _inboundTransfers;
        case TransferDirection.OUT:
          return _outTransfers;
        default:
          return _allTransfers;
      }
    }
  }

  _showDetailsDialog(BuildContext ctx, Transfer transfer) => showDialog(
        context: ctx,
        builder: (_) => AlertDialog(
          title: const Text("Transaction details"),
          content: TransferDetailsWidget(transfer),
        ),
      );
}
