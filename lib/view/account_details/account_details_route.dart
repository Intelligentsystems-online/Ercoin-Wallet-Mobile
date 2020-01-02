import 'dart:async';

import 'package:ercoin_wallet/interactor/account_details/account_details_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/local_account/local_account_activation_details.dart';
import 'package:ercoin_wallet/utils/view/address_qr_code.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/standard_copy_text_box.dart';
import 'package:ercoin_wallet/utils/view/standard_text_box.dart';
import 'package:ercoin_wallet/utils/view/standard_text_form_field.dart';
import 'package:ercoin_wallet/utils/view/stream_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/view/backup/backup_route.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AccountDetailsRoute extends StatefulWidget {
  final LocalAccount account;

  AccountDetailsRoute({@required this.account});

  @override
  _AccountDetailsRouteState createState() => _AccountDetailsRouteState(account);
}

class _AccountDetailsRouteState extends State<AccountDetailsRoute> {
  final LocalAccount account;

  final _interactor = mainInjector.getDependency<AccountDetailsInteractor>();
  final _detailsStream = StreamController<LocalAccountActivationDetails>();
  final _formKey = GlobalKey<FormState>();

  bool _shouldShowPrivateKey = false;
  String _name;

  _AccountDetailsRouteState(this.account);

  @override
  initState() {
    super.initState();
    _updateDetails();
  }

  @override
  void dispose() {
    super.dispose();
    _detailsStream.close();
  }

  @override
  Widget build(BuildContext ctx) => Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Account details")),
      body: StreamBuilderWithProgress(
        stream: _detailsStream.stream,
        builder: (ctx, LocalAccountActivationDetails details) => TopAndBottomContainer(
            top: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      children: <Widget>[
                        _balanceText(details.details.balance),
                        if (!details.details.isRegistered) _notRegisteredWarning(),
                        if (details.isActive) _activeInfo(),
                      ],
                    )),
                    AddressQrCode(address: details.details.localAccount.namedAddress.address),
                  ],
                ),
                _nameBox(),
                const SizedBox(height: 16.0),
                _addressBox(),
                const SizedBox(height: 16.0),
                _privateKeyBox(ctx),
              ],
            ),
            bottom: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: _deleteBtn(ctx, details.details.localAccount)),
                    const SizedBox(width: 8.0),
                    Expanded(child: _backupBtn(ctx)),
                  ],
                ),
                _activationBtn(ctx, details),
                _saveBtn(ctx, details.details.localAccount),
              ],
            )),
      ));

  Widget _balanceText(CoinsAmount balance) => Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text(balance.ercoinFixed, style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8.0),
          const Text("ERN", style: const TextStyle(fontWeight: FontWeight.w300)),
        ],
      );

  Widget _notRegisteredWarning() => Row(
        children: const <Widget>[
          const Icon(Icons.warning, color: Colors.red),
          const SizedBox(width: 8.0),
          const Text(
            "Not registered",
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ],
      );

  Widget _activeInfo() => Row(
        children: const <Widget>[
          const Icon(Icons.check, color: Colors.green),
          const SizedBox(width: 8.0),
          const Text("Active", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      );

  Widget _nameBox() => Form(
      key: _formKey,
      child: StandardTextFormField(
          initialValue: account.namedAddress.name,
          validator: (value) => value.isEmpty ? "Enter name" : null,
          onSaved: (value) => setState(() => _name = value),
          hintText: "Name",
          icon: const Icon(Icons.edit),
      )
  );

  Widget _addressBox() => StandardCopyTextBox(
        value: account.namedAddress.address.base58,
        labelText: "Address",
      );

  Widget _privateKeyBox(BuildContext ctx) => StandardTextBox(
        value: _shouldShowPrivateKey ? account.privateKey.base58 : "Private key hidden",
        labelText: "Private key",
        suffixIcon: Icon(_shouldShowPrivateKey ? Icons.content_copy : Icons.remove_red_eye),
        onSuffixPressed: () async {
          if (_shouldShowPrivateKey) {
            copyToClipboardWithSnackbar(ctx, value: account.privateKey.base58);
          } else {
            await showOkDialog(
              ctx,
              content: const Text(
                  "Private key gives full access over this account and all its funds. Do not share it with anyone",
              ),
            );
            setState(() => _shouldShowPrivateKey = true);
          }
        },
      );

  Widget _deleteBtn(BuildContext ctx, LocalAccount account) => OutlineButton.icon(
        textColor: Colors.red,
        borderSide: BorderSide(color: Theme.of(ctx).primaryColor),
        icon: const Text("Delete"),
        label: const Icon(Icons.delete),
        onPressed: () async => _onDeleteAttempt(),
      );

  _onDeleteAttempt() async {
    showAlertDialog(
      context,
      content: const Text("Before proceed we recommend to make sure that you wrote down access keys"),
      onProceed: () async => _onDeleteHintAccepted()
    );
  }

  _onDeleteHintAccepted() async {
    Navigator.of(context).pop();
    showAlertDialog(
        context,
        title: const Text("Are you sure to remove account?"),
        onProceed: () async => _onDeleteProceed());
  }

  _onDeleteProceed() async {
    await _interactor.deleteAccountByPublicKey(account.namedAddress.address.base58);
    resetRoute(Navigator.of(context), () => HomeRoute(initialPageIndex: 3));
  }

  Widget _backupBtn(BuildContext ctx) => OutlineButton(
        borderSide: BorderSide(color: Theme.of(ctx).primaryColor),
        child: const Text("Create backup"),
        onPressed: () => pushRoute(Navigator.of(ctx), () => BackupRoute(localAccount: account)),
      );

  Widget _activationBtn(BuildContext ctx, LocalAccountActivationDetails details) => OutlineButton(
      borderSide: BorderSide(color: Theme.of(ctx).primaryColor),
      child: Text(details.isActive ? "Deactivate" : "Activate"),
      onPressed: () async {
        await _interactor.toggleAccountActivation(details);
        _updateDetails();
      });

  Widget _saveBtn(BuildContext ctx, LocalAccount account) => RaisedButton(
      child: const Text("Save"),
      onPressed: () async {
        if(_formKey.currentState.validate()) {
          _formKey.currentState.save();

          await _interactor.updateNameByPublicKey(account.namedAddress.address.base58, _name);
          resetRoute(Navigator.of(ctx), () => HomeRoute(initialPageIndex: 3));
        }
      }
  );

  _updateDetails() async => _detailsStream.add(await _interactor.obtainAccountActivationDetails(account));
}
