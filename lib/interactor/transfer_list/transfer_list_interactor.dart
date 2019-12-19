import 'dart:async';

import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:ercoin_wallet/model/transfer/transfer_direction.dart';
import 'package:ercoin_wallet/service/transfer/transfer_service.dart';

class TransferListInteractor {
  final TransferService _transferService;

  TransferListInteractor(this._transferService);

  Future<List<List<Transfer>>> obtainTransferLists() async {
    final all = await _transferService.obtainTransferList();
    final inbound = _filterBy(TransferDirection.IN, all);
    final outbound = _filterBy(TransferDirection.OUT, all);

    all.sort(_compareByTimestamp);
    inbound.sort(_compareByTimestamp);
    outbound.sort(_compareByTimestamp);

    return [all, inbound, outbound];
  }

  List<Transfer> _filterBy(TransferDirection direction, List<Transfer> transferList) => transferList
      .where((transfer) => transfer.direction == direction)
      .toList();

  int _compareByTimestamp(Transfer t1, Transfer t2) =>
      t2.data.timestamp.compareTo(t1.data.timestamp);
}
