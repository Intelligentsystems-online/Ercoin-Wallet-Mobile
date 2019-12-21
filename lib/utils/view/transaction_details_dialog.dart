
/*import 'package:ercoin_wallet/model/Transaction.dart';
import 'package:ercoin_wallet/utils/service/common/date_util.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionDetailsDialog extends StatelessWidget {
  final Transaction transaction;

  final _dateUtil = DateUtil();

  TransactionDetailsDialog(this.transaction);

  @override
  Widget build(BuildContext ctx) => Dialog(
    shape: const RoundedRectangleBorder(borderRadius: standardBorderRadius),
    child: Container(
      padding: standardDialogPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _coinsInfoText(ctx),
          const SizedBox(height: 16.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _labelsColumn(),
              const SizedBox(width: 8.0),
              Expanded(child: _valuesColumn()),
            ],
          ),
          const SizedBox(height: 16.0),
          _closeBtn(ctx),
        ],
      )
    ),
  );

  Widget _coinsInfoText(BuildContext ctx) => Text(
    transaction.coins < 0 ? "${transaction.coins}" : "+${transaction.coins}",
    style: TextStyle(fontSize: 30.0, color: transaction.coins < 0 ? Colors.redAccent : Colors.lightGreen)
  );

  Widget _labelsColumn() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text("Message:"),
      const Text("From:"),
      const Text("To:"),
      const Text("Timestamp:"),
    ],
  );

  Widget _valuesColumn() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(transaction.message, maxLines: 1, overflow: TextOverflow.ellipsis),
      Text(transaction.senderAddress, maxLines: 1, overflow: TextOverflow.ellipsis),
      Text(transaction.receiverAddress, maxLines: 1, overflow: TextOverflow.ellipsis),
    ],
  );

  Widget _closeBtn(BuildContext ctx) => ExpandedRaisedTextButton(
    text: "Close",
    onPressed: () => Navigator.of(ctx).pop(),
  );
}
*/
