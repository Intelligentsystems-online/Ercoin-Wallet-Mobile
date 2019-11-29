import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TermsRoute extends StatefulWidget {
  final Function(BuildContext) onProceed;

  const TermsRoute({@required this.onProceed});

  @override
  _TermsRouteState createState() => _TermsRouteState(onProceed: onProceed);
}

class _TermsRouteState extends State<TermsRoute> {
  final Function(BuildContext) onProceed;

  bool _isAccepted = false;

  _TermsRouteState({this.onProceed});

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
        child: RaisedButton(child: const Text("Proceed"), onPressed: (_isAccepted ? () => onProceed(context) : null)),
      );
}
