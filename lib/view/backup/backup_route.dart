import 'package:ercoin_wallet/interactor/backup/backup_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/standard_copy_text_box.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/backup/backup_success_dialog.dart';
import 'package:flutter/material.dart';

class BackupRoute extends StatelessWidget {
  final Function(BuildContext) onProceed;
  final LocalAccount localAccount;

  final _interactor = mainInjector.getDependency<BackupInteractor>();

  BackupRoute({this.onProceed, @required this.localAccount});

  @override
  Widget build(BuildContext ctx) => Scaffold(
        appBar: AppBar(title: const Text("Account backup")),
        body: TopAndBottomContainer(
          top: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                  "Create account backup by writing down and/or exporting to file following data. This will allow you to use this account from different device or restore it after data loss."),
              const SizedBox(height: 16.0),
              StandardCopyTextBox(labelText: "Name", value: localAccount.namedAddress.name),
              const SizedBox(height: 16.0),
              StandardCopyTextBox(labelText: "Address", value: localAccount.namedAddress.address.base58),
              const SizedBox(height: 16.0),
              StandardCopyTextBox(labelText: "Private key", value: localAccount.privateKey.base58),
            ],
          ),
          bottom: Builder(
            builder: (ctx) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _backupBtn(ctx),
                if (onProceed != null) _proceedBtn(ctx),
              ],
            ),
          ),
        ),
      );

  Widget _backupBtn(BuildContext ctx) => RaisedButton(
        child: const Text("Export to file"),
        onPressed: () async {
          final filePath = await _interactor.createBackup(localAccount);
          showDialog(context: ctx, child: BackupSuccessDialog(backupPath: filePath));
        },
      );

  Widget _proceedBtn(BuildContext ctx) => ExpandedRaisedTextButton(text: "Proceed", onPressed: () => onProceed(ctx));
}
