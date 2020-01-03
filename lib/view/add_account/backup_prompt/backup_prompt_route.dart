import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/view/backup/backup_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BackupPromptRoute extends StatelessWidget {
  final Function(BuildContext) onAdded;
  final LocalAccount localAccount;

  const BackupPromptRoute({@required this.onAdded, @required this.localAccount});

  @override
  Widget build(BuildContext ctx) => Scaffold(
        appBar: AppBar(title: const Text("Account backup")),
        body: TopAndBottomContainer(
          top: ExpandedRow(child: _infoText()),
          bottom: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _proceedWithoutBackupBtn(ctx),
              _backupBtn(ctx),
            ],
          ),
        ),
      );

  Widget _infoText() => const Text(
      "We strongly advise to create backup. By proceeding without backup you acknowledge that you can lose access to your account");

  Widget _backupBtn(BuildContext ctx) => RaisedButton(
        child: const Text("Create backup"),
        onPressed: () => pushRoute(
          Navigator.of(ctx),
          () => BackupRoute(localAccount: localAccount, onProceed: onAdded),
        ),
      );

  Widget _proceedWithoutBackupBtn(BuildContext ctx) => OutlineButton.icon(
        textColor: Colors.red,
        borderSide: BorderSide(color: Theme.of(ctx).primaryColor),
        label: const Icon(Icons.warning),
        icon: const Text("Proceed without backup"),
//        onPressed: () => onAdded(ctx),
        onPressed: () => onAdded(ctx),
      );
}
