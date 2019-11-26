import 'package:ercoin_wallet/utils/expanded_row.dart';
import 'package:ercoin_wallet/utils/navigation_utils.dart';
import 'package:ercoin_wallet/utils/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TermsRoute extends StatefulWidget {
  final WidgetBuilder afterAccepted;

  const TermsRoute({@required this.afterAccepted});

  @override
  _TermsRouteState createState() => _TermsRouteState(afterAccepted: afterAccepted);
}

class _TermsRouteState extends State<TermsRoute> {
  final WidgetBuilder afterAccepted;

  bool _isAccepted = false;

  _TermsRouteState({this.afterAccepted});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text("Terms"),
      ),
      body: Container(
        padding: standardPadding,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: FractionalOffset.topCenter,
              child: _termsRow(),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: _proceedBtn(),
            ),
          ],
        ),
      ));

  Widget _termsRow() => Row(
        children: <Widget>[
          Checkbox(
            value: _isAccepted,
            onChanged: (isChecked) => setState(() => _isAccepted = isChecked),
          ),
          const Expanded(
            child: const Text("I accept terms"), // TODO(Add terms text)
          )
        ],
      );

  Widget _proceedBtn() => ExpandedRow(
        child: RaisedButton(
            child: const Text("Proceed"), onPressed: (_isAccepted ? () => moveTo(context, afterAccepted) : null)),
      );
}
