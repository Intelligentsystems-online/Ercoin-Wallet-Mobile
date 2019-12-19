import 'package:ercoin_wallet/interactor/transfer/transfer_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/api/api_response_status.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/standard_text_form_field.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

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
  String _message = "";
  bool _isInsufficientFundsError = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _interactor = mainInjector.getDependency<TransferInteractor>();

  _TransferRouteState(this.destinationAddress, this.destinationName);

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
                _amountInput(),
                _messageInput(),
              ],
            ),
          ),
          bottom: _sendBtn(),
        ),
      ));

  Widget _amountInput() => ExpandedRow(
    child: StandardTextFormField(
      hintText: "Amount",
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: _validateAmount,
      onSaved: (value) => setState(() => _amount = double.parse(value)),
    ),
  );

  Widget _messageInput() => ExpandedRow(
    child: StandardTextFormField(
      hintText: "Message",
      onSaved: (value) => setState(() => _message = value),
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
        _formKey.currentState.save();
        setState(() => _isLoading = true);
        final transferResult = await _interactor.sendTransfer(Address(publicKey: destinationAddress), _message, CoinsAmount(ercoin: _amount));
        setState(() => _isLoading = false);
        _processTransferResult(transferResult);
      }
    },
  );

  _processTransferResult(ApiResponseStatus result) {
    if(result == ApiResponseStatus.INSUFFICIENT_FUNDS) {
      setState(() => _isInsufficientFundsError = true);
      _formKey.currentState.validate();
    } else if(result == ApiResponseStatus.GENERIC_ERROR) {
      _onTransferUnknownError();
    }
    else {
      resetRoute(Navigator.of(context), () => HomeRoute());
    }
  }

  _onTransferUnknownError() => Builder(builder: (context) => _showSnackBar(context));

  _showSnackBar(BuildContext context) => Scaffold.of(context).showSnackBar(SnackBar(
    content: const Text("Something went wrong, try again")
  ));
}
