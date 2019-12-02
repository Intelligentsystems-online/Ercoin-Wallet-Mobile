import 'package:ercoin_wallet/interactor/transfer/send_transfer_error.dart';
import 'package:ercoin_wallet/interactor/transfer/transfer_interactor.dart';
import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransferRoute extends StatefulWidget {
  final String destinationAddress;
  final String destinationName;

  const TransferRoute({@required this.destinationAddress, this.destinationName});

  @override
  _TransferRouteState createState() => _TransferRouteState(this.destinationAddress, this.destinationName);
}

class _TransferRouteState extends State<TransferRoute> {
  final String destinationAddress;
  final String destinationName;

  double _amount;
  bool _isInsufficientFundsError = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _interactor = TransferInteractor(); // TODO(DI)

  _TransferRouteState(this.destinationName, this.destinationAddress);

  @override
  Widget build(BuildContext ctx) => Scaffold(
      appBar: AppBar(
        title: const Text("Transfer ercoin"),
      ),
      body: ProgressOverlayContainer(
        overlayEnabled: _isLoading,
        child: TopAndBottomContainer(
          top: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text("Destination address: $destinationAddress"),
                destinationName != null ? Text("Name: $destinationName") : Container(),
                _amountInput()
              ],
            ),
          ),
          bottom: _sendBtn(),
        ),
      ));

  Widget _amountInput() => ExpandedRow(
    child: TextFormField(
      decoration: const InputDecoration(labelText: "Amount"),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: _validateAmount,
      onSaved: (value) => setState(() => _amount = double.parse(value)),
    ),
  );

  String _validateAmount(String value) {
    if(value.isEmpty) {
      return "Enter amount";
    } else if(_isInsufficientFundsError) {
      _isInsufficientFundsError = false;
      return "Insufficient funds";
    } else {
      return null;
    }
  }

  Widget _sendBtn() => ExpandedRaisedTextButton(
    text: "Send",
    onPressed: () async {
      if(_formKey.currentState.validate()) {
        setState(() => _isLoading = true);
        final error = await _interactor.sendTransfer(destinationAddress, destinationName, _amount);
        setState(() => _isLoading = false);
        if(error == SendTransferError.INSUFFICIENT_FUNDS) {
          setState(() => _isInsufficientFundsError = true);
          _formKey.currentState.validate();
        } else {
          resetRoute(Navigator.of(context), () => HomeRoute());
        }
      }
    },
  );
}
