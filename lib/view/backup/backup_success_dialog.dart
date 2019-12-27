import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/standard_copy_text_box.dart';
import 'package:ercoin_wallet/utils/view/standard_text_box.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class BackupSuccessDialog extends StatelessWidget {
  final String backupPath;

  const BackupSuccessDialog({@required this.backupPath});

  @override
  Widget build(BuildContext ctx) => AlertDialog(
    shape: const RoundedRectangleBorder(borderRadius: standardBorderRadius),
    contentPadding: standardDialogPadding,
    title: Text(
      "Exported successfully",
      textAlign: TextAlign.center,
      style: Theme.of(ctx).textTheme.title,
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StandardTextBox(
          labelText: "File path",
          value: backupPath,
          suffixIcon: const Icon(Icons.content_copy),
          onSuffixPressed: () async => await Clipboard.setData(ClipboardData(text: backupPath)),
        ),
        const SizedBox(height: 16.0),
        OutlineButton(
          borderSide: BorderSide(color: Theme.of(ctx).primaryColor),
          child: const Text("Close"),
          onPressed: () => Navigator.pop(ctx),
        ),
      ],
    )
  );
}
