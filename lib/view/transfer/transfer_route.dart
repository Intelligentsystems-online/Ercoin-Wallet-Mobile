import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/api/api_response_status.dart';
import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';
import 'package:ercoin_wallet/utils/view/decimal_input_formatter.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/progress_overlay_container.dart';
import 'package:ercoin_wallet/utils/view/standard_copy_text_box.dart';
import 'package:ercoin_wallet/utils/view/standard_text_form_field.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:ercoin_wallet/view/transfer/confirm/transfer_confirm_route.dart';

import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class TransferRoute extends StatefulWidget {
  final Address destinationAddress;
  final String destinationName;

  const TransferRoute({@required this.destinationAddress, this.destinationName});

  @override
  _TransferRouteState createState() => _TransferRouteState(this.destinationAddress, this.destinationName);
}

class _TransferRouteState extends State<TransferRoute> {
  final Address destination;
  final String destinationName;

  double _amount;
  String _message = "";

  final _formKey = GlobalKey<FormState>();

  _TransferRouteState(this.destination, this.destinationName);

  @override
  Widget build(BuildContext ctx) => Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Transfer")),
      body: TopAndBottomContainer(
        top: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StandardCopyTextBox(
                labelText: "Destination",
                value: destinationName ?? destination.base58,
                clipboardValue: destination.base58,
                onCopiedText: "Address copied to clipboard",
              ),
              const SizedBox(height: 16.0),
              _amountInput(),
              const SizedBox(height: 16.0),
              _messageInput(),
            ],
          ),
        ),
        bottom: Builder(builder: (ctx) => _sendBtn(ctx)),
      ));

  Widget _amountInput() => StandardTextFormField(
        hintText: "Amount",
        icon: const Icon(Icons.edit),
        inputFormatters: [DecimalInputFormatter(decimalRange: 6)],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        validator: (value) => value.isEmpty ? "Enter amount" : null,
        onSaved: (value) => setState(() => _amount = double.parse(value)),
      );

  Widget _messageInput() => StandardTextFormField(
        hintText: "Message (optional)",
        icon: const Icon(Icons.edit),
        onSaved: (value) => setState(() => _message = value),
      );

  Widget _sendBtn(BuildContext ctx) => ExpandedRow(
        child: RaisedButton.icon(
          icon: const Text("Transfer"),
          label: const Icon(Icons.send),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              pushRoute(Navigator.of(ctx), () => TransferConfirmRoute(
                destination: destination,
                destinationName: destinationName,
                amount: CoinsAmount(ercoin: _amount),
                message: _message ?? "",
              ));
            }
          },
        ),
      );
}
