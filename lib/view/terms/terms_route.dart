import 'package:ercoin_wallet/utils/view/checkbox_with_text.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
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
        child: TopAndBottomContainer(
          top: _termsRow(),
          bottom: _proceedBtn(),
        )
      ));

  Widget _termsRow() => CheckboxWithTextWidget(
    text: "I accept terms",
    value: _isAccepted,
    onChanged: (isChecked) => setState(() => _isAccepted = isChecked)
  );

  Widget _proceedBtn() => ExpandedRow(
        child: RaisedButton(child: const Text("Proceed"), onPressed: (_isAccepted ? () => onProceed(context) : null)),
      );
}
