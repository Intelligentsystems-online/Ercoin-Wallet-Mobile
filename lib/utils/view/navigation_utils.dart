import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

pushRoute(NavigatorState navigator, Function() builder) => navigator.push(MaterialPageRoute(builder: (_) => builder()));

resetRoute(NavigatorState navigator, Function() builder) {
  navigator.popUntil((route) => route.isFirst);
  navigator.pushReplacement(MaterialPageRoute(builder: (_) => builder()));
}

showTextSnackBar(ScaffoldState scaffold, String text) {
  scaffold.removeCurrentSnackBar();
  scaffold.showSnackBar(SnackBar(content: Text(text)));
}

copyToClipboardWithSnackbar(BuildContext ctx, {@required String value, String snackbarText}) async {
  await Clipboard.setData(ClipboardData(text: value));
  showTextSnackBar(Scaffold.of(ctx), snackbarText ?? "Copied to clipboard");
}

Future showOkDialog(BuildContext ctx, {@required Widget content, Widget title}) async {
  await showDialog(
    context: ctx,
    builder: (ctx) => AlertDialog(
      content: content,
      title: title,
      actions: <Widget>[FlatButton(child: const Text("Close"), onPressed: () => Navigator.pop(ctx))],
    ),
  );
}
