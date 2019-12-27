import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/utils/view/address_qr_code.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/standard_copy_text_box.dart';
import 'package:ercoin_wallet/utils/view/standard_text_form_field.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/view/transfer/transfer_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressDetailsRoute extends StatefulWidget {
  final NamedAddress address;

  const AddressDetailsRoute({@required this.address});

  @override
  _AddressDetailsRouteState createState() => _AddressDetailsRouteState(address);
}

class _AddressDetailsRouteState extends State {
  final NamedAddress _address;

  String _name;

  _AddressDetailsRouteState(this._address);

  @override
  Widget build(BuildContext ctx) => Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(title: const Text("Address details")),
        body: TopAndBottomContainer(
          top: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(alignment: Alignment.center, child: AddressQrCode(address: _address.address)),
              const SizedBox(height: 16.0),
              _nameBox(),
              const SizedBox(height: 16.0),
              _addressBox(),
            ],
          ),
          bottom: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[_deleteBtn(ctx), _transferBtn(ctx), _saveBtn()],
          ),
        ),
      );

  Widget _nameBox() => StandardTextFormField(
        initialValue: _address.name,
        hintText: "Name",
        icon: const Icon(Icons.edit),
        validator: (value) => value.isEmpty ? "Enter name" : null,
        onSaved: (value) => _name = value,
      );

  Widget _addressBox() => StandardCopyTextBox(
        value: _address.address.publicKey,
        labelText: "Address",
      );

  Widget _deleteBtn(BuildContext ctx) => OutlineButton.icon(
        borderSide: BorderSide(color: Theme.of(ctx).primaryColor),
        textColor: Colors.red,
        icon: const Text("Delete"),
        label: const Icon(Icons.delete),
        onPressed: () {}, // TODO(Address edit)
      );

  Widget _transferBtn(BuildContext ctx) => OutlineButton.icon(
        borderSide: BorderSide(color: Theme.of(ctx).primaryColor),
        icon: const Text("Transfer"),
        label: const Icon(Icons.send),
        onPressed: () => pushRoute(
          Navigator.of(ctx),
          () => TransferRoute(destinationAddress: _address.address, destinationName: _address.name),
        ),
      );

  Widget _saveBtn() => RaisedButton(
        child: const Text("Save"), onPressed: () {}, // TODO(Address edit)
      );
}
