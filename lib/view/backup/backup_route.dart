import 'package:ercoin_wallet/interactor/backup/backup_interactor.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folder_picker/folder_picker.dart';
import 'package:injector/injector.dart';

class BackupRoute extends StatelessWidget {
  final Function(BuildContext) onProceed;
  final Account account;

  BackupInteractor _interactor; // TODO(DI)

  BackupRoute({this.onProceed, @required this.account}) {
    Injector injector = Injector.appInstance;
    _interactor = injector.getDependency<BackupInteractor>();
  }

  @override
  Widget build(BuildContext ctx) => Scaffold(
        appBar: AppBar(
          title: const Text("Account backup"),
        ),
        body: Container(
            padding: standardPadding,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: FractionalOffset.topLeft,
                  child: Column(
                    children: <Widget>[
                      const Text("Write down following keys:"),
                      _box(name: "Account name", value: account.accountName),
                      _box(name: "Public key", value: account.publicKey),
                      _box(name: "Private key", value: account.privateKey),
                      Builder(builder: _backupBtn),
                    ],
                  ),
                ),
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: (onProceed == null) ? Container() : Builder(builder: _proceedBtn),
                )
              ],
            )),
      );

  Widget _box({String name, String value}) => ExpandedRow(
        child: TextFormField(
          decoration: InputDecoration(labelText: name),
          enabled: false,
          initialValue: value,
        ),
      );

  Widget _backupBtn(BuildContext ctx) =>
      ExpandedRaisedTextButton(text: "Backup to file", onPressed: () => _backupToFile(ctx));

  Widget _proceedBtn(BuildContext ctx) => ExpandedRaisedTextButton(text: "Proceed", onPressed: () => onProceed(ctx));

  _backupToFile(BuildContext ctx) async {
    final filePath = await _interactor.createBackup(account);
    Scaffold.of(ctx).showSnackBar(SnackBar(content: Text("Account saved to $filePath")));
  }
}
