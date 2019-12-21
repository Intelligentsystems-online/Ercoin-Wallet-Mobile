import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'navigation_utils.dart';

class StandardCopyTextBox extends StatelessWidget {
  final String value;
  final String labelText;
  final String clipboardValue;
  final String onCopiedText;

  const StandardCopyTextBox({@required this.value, this.labelText, this.clipboardValue, this.onCopiedText});

  @override
  Widget build(BuildContext ctx) => InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: standardTextFieldBorder,
          contentPadding: standardTextFieldContentPadding,
          suffixIcon: IconButton(
            icon: const Icon(Icons.content_copy),
            onPressed: () => _setToClipboard(ctx),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(value, maxLines: 1),
        ),
      );

  _setToClipboard(BuildContext ctx) async {
    await Clipboard.setData(ClipboardData(text: clipboardValue ?? value));
    showTextSnackBar(Scaffold.of(ctx), onCopiedText ?? "Copied to clipboard");
  }
}
