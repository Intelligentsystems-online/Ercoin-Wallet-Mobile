import 'package:ercoin_wallet/utils/view/standard_text_box.dart';
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
  Widget build(BuildContext ctx) => StandardTextBox(
        value: value,
        labelText: labelText,
        suffixIcon: const Icon(Icons.content_copy),
        onSuffixPressed: () async => copyToClipboardWithSnackbar(
            ctx,
            value: clipboardValue ?? value,
            snackbarText: onCopiedText
        ),
      );
}
