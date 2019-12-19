import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/backup/backup_route.dart';
import 'package:flutter/material.dart';

class BackupPromptRoute extends StatelessWidget {
  final Function(BuildContext) onAdded;
  final LocalAccount localAccount;

  const BackupPromptRoute({@required this.onAdded, @required this.localAccount});

  @override
  Widget build(BuildContext ctx) => Scaffold(
        appBar: AppBar(
          title: const Text("Account backup"),
        ),
        body: Container(
          padding: standardPadding,
          child: Column(
            children: <Widget>[_infoText(), _backupBtn(ctx), _proceedBtn(ctx)],
          ),
        ),
      );

  Widget _infoText() => const ExpandedRow(
        child: const Text("We strongly advise to create backup. By proceeding without backup you acknowledge that" +
            " you can lose access to your account"),
      );

  Widget _backupBtn(BuildContext ctx) => ExpandedRow(
        child: RaisedButton(
          child: const Text("Create backup"),
          onPressed: () => _createBackup(ctx),
        ),
      );

  Widget _proceedBtn(BuildContext ctx) => ExpandedRow(
        child: RaisedButton(
          child: const Text("Proceed without backup"),
          onPressed: () => onAdded(ctx),
        ),
      );

  _createBackup(BuildContext ctx) {
    final navigator = Navigator.of(ctx);
    pushRoute(navigator, () => BackupRoute(localAccount: localAccount, onProceed: onAdded));
  }
}
