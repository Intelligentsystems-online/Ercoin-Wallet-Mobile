import 'package:ercoin_wallet/model/transfer/transfer.dart';
import 'package:ercoin_wallet/model/transfer/utils/transfers.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/transfer_details/transfer_details_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TransferList extends StatelessWidget {
  final List<Transfer> list;

  TransferList({this.list});

  @override
  Widget build(BuildContext ctx) => ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (ctx, index) => _transactionRow(ctx, list[index]));

  Widget _transactionRow(BuildContext ctx, Transfer transfer) => GestureDetector(
        onTap: () => pushRoute(Navigator.of(ctx), () => TransferDetailsRoute(transfer: transfer)),
        child: Card(
          child: Container(
            padding: standardPadding + standardPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _transferIcon(transfer),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _messageText(transfer, ctx),
                      _addressText(transfer, ctx),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                _amountText(transfer),
              ],
            ),
          ),
        ),
      );

  Widget _transferIcon(Transfer transfer) =>
      Icon(Transfers.byDirection(transfer, onIn: Icons.call_received, onOut: Icons.call_made));

  Widget _amountText(Transfer transfer) => Text(
        Transfers.deltaAmountErcoinSigned(transfer),
        style: TextStyle(color: Transfers.byDirection(transfer, onIn: Colors.green, onOut: Colors.black)),
      );

  Widget _addressText(Transfer transfer, BuildContext ctx) {
    final direction = Transfers.byDirection(transfer, onIn: "From", onOut: "To");
    final name = Transfers.foreignAddressNameOrPublicKey(transfer);
    return Text(
      "$direction:\u00A0$name",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(ctx).textTheme.caption,
    );
  }

  Text _messageText(Transfer transfer, BuildContext ctx) => Text(
        transfer.data.message.isEmpty ? "No message" : transfer.data.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(ctx).textTheme.body2,
      );
}
