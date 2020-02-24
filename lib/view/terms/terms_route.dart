import 'package:ercoin_wallet/utils/view/checkbox_with_text.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
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
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[_termsContent(), _termsRow()],
                  )
                )
            ),
            _proceedBtn()
          ]
      )
  );

  Widget _termsContent() => Text("There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.. There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.");

  Widget _termsRow() => CheckboxWithTextWidget(
    text: "I accept terms",
    value: _isAccepted,
    onChanged: (isChecked) => setState(() => _isAccepted = isChecked)
  );

  Widget _proceedBtn() => ExpandedRaisedTextButton(
    text: "Procced",
    onPressed: _isAccepted ? () => onProceed(context) : null,
  );
}
