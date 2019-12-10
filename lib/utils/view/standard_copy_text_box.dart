import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StandardCopyTextBox extends StatelessWidget {
  final String value;
  final String labelText;

  const StandardCopyTextBox({@required this.value, this.labelText});

  @override
  Widget build(BuildContext ctx) => TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: standardTextFieldBorder,
          contentPadding: standardTextFieldContentPadding,
          suffixIcon: IconButton(
            icon: const Icon(Icons.content_copy),
            onPressed: () => Clipboard.setData(ClipboardData(text: value)).then((_) => _showCopiedSnackbar(ctx)),
          ),
        ),
        readOnly: true,
        focusNode: FocusNode(canRequestFocus: false),
        initialValue: value,
      );

  _showCopiedSnackbar(BuildContext ctx) => Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: const Text("Copied to clipboard"),
        ),
      );
}
