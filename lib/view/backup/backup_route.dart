import 'package:ercoin_wallet/interactor/backup/backup_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/standard_copy_text_box.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackupRoute extends StatelessWidget {
  final Function(BuildContext) onProceed;
  final LocalAccount localAccount;

  final _interactor = mainInjector.getDependency<BackupInteractor>();

  BackupRoute({this.onProceed, @required this.localAccount});

  @override
  Widget build(BuildContext ctx) => Scaffold(
        appBar: AppBar(
          title: const Text("Account backup"),
        ),
        body: TopAndBottomContainer(
          top: Column(
            children: <Widget>[
              const Text("Write down following keys:"),
              Padding(padding: standardColumnSpacing),
              _box(name: "Account name", value: localAccount.namedAddress.name),
              Padding(padding: standardColumnSpacing),
              _box(name: "Public key", value: localAccount.namedAddress.address.base58),
              Padding(padding: standardColumnSpacing),
              _box(name: "Private key", value: localAccount.privateKey.privateKey),
              Builder(builder: _backupBtn),
            ],
          ),
          bottom: (onProceed == null) ? Container() : Builder(builder: _proceedBtn),
        ),
      );

  Widget _box({String name, String value}) => ExpandedRow(
        child: StandardCopyTextBox(
          labelText: name,
          value: value,
        ),
      );

  Widget _backupBtn(BuildContext ctx) =>
      ExpandedRaisedTextButton(text: "Backup to file", onPressed: () => _backupToFile(ctx));

  Widget _proceedBtn(BuildContext ctx) => ExpandedRaisedTextButton(text: "Proceed", onPressed: () => onProceed(ctx));

  _backupToFile(BuildContext ctx) async {
    final filePath = await _interactor.createBackup(localAccount);
    showTextSnackBar(Scaffold.of(ctx), "Account saved to $filePath");
  }
}
