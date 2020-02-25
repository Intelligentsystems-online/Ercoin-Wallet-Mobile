import 'package:ercoin_wallet/interactor/transfer/confirm/transfer_confirm_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/api/api_response_status.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/standard_copy_text_box.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransferConfirmRoute extends StatefulWidget {
  final Address destination;
  final String destinationName;
  final CoinsAmount amount;
  final String message;

  const TransferConfirmRoute({
    @required this.destination,
    this.destinationName,
    @required this.amount,
    @required this.message
  });

  @override
  _TransferConfirmRouteState createState() =>
      _TransferConfirmRouteState(destination, destinationName, amount, message);
}

class _TransferConfirmRouteState extends State<TransferConfirmRoute> {
  final Address destination;
  final String destinationName;
  final CoinsAmount amount;
  final String message;

  bool _isLoading = false;

  final _interactor = mainInjector.getDependency<TransferConfirmInteractor>();

  _TransferConfirmRouteState(this.destination, this.destinationName, this.amount, this.message);

  @override
  Widget build(BuildContext ctx) => Scaffold(
    appBar: AppBar(title: const Text("Confirm transfer")),
    body: ProgressOverlayContainer(
      overlayEnabled: _isLoading,
      child: TopAndBottomContainer(
        top: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text("Check following data. After you execute a transfer, it cannot be canceled."),
            const SizedBox(height: 16.0),
            StandardCopyTextBox(
              labelText: "Destination",
              value: destinationName ?? destination.base58
            ),
            const SizedBox(height: 16.0),
            StandardCopyTextBox(
              labelText: "Amount (ERN)",
              value: amount.ercoinFixed,
            ),
            const SizedBox(height: 16.0),
            StandardCopyTextBox(
              labelText: "Message",
              value: message.isEmpty ? "No message" : message,
            ),
          ],
        ),
        bottom: Builder(
          builder: (ctx) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OutlineButton.icon(
                borderSide: BorderSide(color: Theme.of(ctx).primaryColor),
                icon: const Text("Change data"),
                label: const Icon(Icons.edit),
                onPressed: () => Navigator.pop(ctx),
              ),
              RaisedButton.icon(
                icon: const Text("Send"),
                label: const Icon(Icons.send),
                onPressed: () => _send(ctx),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  _send(BuildContext ctx) async {
    setState(() => _isLoading = true);
    final result = await _interactor.sendTransfer(destination, message, amount);
    setState(() => _isLoading = false);
    _processTransferResult(ctx, result);
  }

  _processTransferResult(BuildContext ctx, ApiResponseStatus result) {
    if (result == ApiResponseStatus.INSUFFICIENT_FUNDS) {
      showTextSnackBar(Scaffold.of(ctx), "Insufficient funds to execute this transfer");
    } else if (result == ApiResponseStatus.GENERIC_ERROR) {
      showTextSnackBar(Scaffold.of(ctx), "Something went wrong, wait a moment and try again");
    } else {
      resetRoute(Navigator.of(context), () => HomeRoute(initialPageIndex: 1, snackBarText: "Transfer successful"));
    }
  }
}
