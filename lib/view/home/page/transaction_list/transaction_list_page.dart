import 'package:ercoin_wallet/interactor/transaction_list/transaction_list_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/transaction_details_widget.dart';
import 'package:ercoin_wallet/utils/view/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class TransactionListPage extends StatefulWidget {
  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

enum _TransactionFilterType { INBOUND, OUTGOING }

class _TransactionListPageState extends State<TransactionListPage> {
  _TransactionFilterType _filterType;
  List<Transaction> _transactions, _inboundTransactions, _outgoingTransactions;

  final _interactor = mainInjector.getDependency<TransactionListInteractor>();

  @override
  void initState() {
    _loadTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) => ProgressOverlayContainer(
        overlayEnabled: _transactions == null,
        child: Column(
          children: <Widget>[
            _filterChips(),
            TransactionList(
              transactions: _obtainFilteredTransactions(),
              onTransactionPressed: (transaction) => _showDetailsDialog(ctx, transaction),
            )
          ],
        ),
      );

  Widget _filterChips() => Row(
        children: <Widget>[
          ChoiceChip(
            label: const Text("Inbound"),
            selected: _filterType == _TransactionFilterType.INBOUND,
            onSelected: (isSelected) =>
                setState(() => _filterType = isSelected ? _TransactionFilterType.INBOUND : null),
          ),
          ChoiceChip(
            label: const Text("Outgoing"),
            selected: _filterType == _TransactionFilterType.OUTGOING,
            onSelected: (isSelected) =>
                setState(() => _filterType = isSelected ? _TransactionFilterType.OUTGOING : null),
          )
        ],
      );

  _loadTransactions() async {
    final transactionLists = await _interactor.obtainTransactionLists();

    setState(() {
      _transactions = transactionLists[0];
      _inboundTransactions = transactionLists[1];
      _outgoingTransactions = transactionLists[2];
    });
  }

  List<Transaction> _obtainFilteredTransactions() {
    if (_transactions == null) {
      return [];
    } else {
      switch (_filterType) {
        case _TransactionFilterType.INBOUND:
          return _inboundTransactions;
        case _TransactionFilterType.OUTGOING:
          return _outgoingTransactions;
        default:
          return _transactions;
      }
    }
  }

  _showDetailsDialog(BuildContext ctx, Transaction transaction) => showDialog(
        context: ctx,
        builder: (_) => AlertDialog(
          title: const Text("Transaction details"),
          content: TransactionDetailsWidget(transaction),
        ),
      );
}
