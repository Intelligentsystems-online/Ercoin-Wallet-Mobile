import 'package:ercoin_wallet/interactor/address_details/address_details_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/utils/view/address_qr_code.dart';
import 'package:ercoin_wallet/utils/view/delete_alert_dialog.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/standard_copy_text_box.dart';
import 'package:ercoin_wallet/utils/view/standard_text_form_field.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:ercoin_wallet/view/transfer/transfer_route.dart';

import 'package:flutter/material.dart';

class AddressDetailsRoute extends StatefulWidget {
  final NamedAddress address;

  const AddressDetailsRoute({@required this.address});

  @override
  _AddressDetailsRouteState createState() => _AddressDetailsRouteState(address);
}

class _AddressDetailsRouteState extends State<AddressDetailsRoute> {
  final NamedAddress _address;

  final _interactor = mainInjector.getDependency<AddressDetailsInteractor>();
  final _formKey = GlobalKey<FormState>();

  String _name;

  _AddressDetailsRouteState(this._address);

  @override
  Widget build(BuildContext ctx) => Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(title: const Text("Address details")),
        body: FutureBuilderWithProgress(
          future: _interactor.isActiveAccountRegistered(),
          builder: (bool isActiveAccountRegistered) => TopAndBottomContainer(
            top: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 16.0),
              Align(alignment: Alignment.center, child: AddressQrCode(address: _address.address)),
              const SizedBox(height: 32.0),
                _nameBox(ctx),
                const SizedBox(height: 16.0),
                _addressBox(),
              ],
            ),
            bottom: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[_deleteBtn(ctx), if(isActiveAccountRegistered) _transferBtn(ctx)],
            ),
          ),
        )
      );

  Widget _nameBox(BuildContext ctx) => Form(
      key: _formKey,
      child: StandardTextFormField(
        initialValue: _address.name,
        hintText: "Name",
        icon: const Icon(Icons.edit),
        onFocusLost: () => _save(ctx),
        validator: (value) => value.isEmpty ? "Enter name" : null,
        onSaved: (value) => setState(() => _name = value),
      ));

  Widget _addressBox() => StandardCopyTextBox(
        value: _address.address.base58,
        labelText: "Address",
      );

  Widget _deleteBtn(BuildContext ctx) => OutlineButton.icon(
        borderSide: BorderSide(color: Theme.of(ctx).primaryColor),
        textColor: Colors.red,
        icon: const Text("Delete"),
        label: const Icon(Icons.delete),
        onPressed: () async => await _onDeleteAttempt(ctx),
      );

  _onDeleteAttempt(BuildContext ctx) async {
    showDialog(context: ctx, builder: (ctx) => DeleteAlertDialog((ctx) async => await _onDeleteProceed(ctx)));
  }

  _onDeleteProceed(BuildContext ctx) async {
    await _interactor.deleteAddressByPublicKey(_address.address.base58);
    resetRoute(Navigator.of(ctx), () => HomeRoute(initialPageIndex: 2));
  }

  Widget _transferBtn(BuildContext ctx) => RaisedButton.icon(
        icon: const Text("Transfer"),
        label: const Icon(Icons.send),
        onPressed: () => pushRoute(
          Navigator.of(ctx),
          () => TransferRoute(destinationAddress: _address.address, destinationName: _address.name),
        ),
      );

  _save(BuildContext ctx) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      await _interactor.updateNameByPublicKey(_address.address.base58, _name);
    }
  }
}
