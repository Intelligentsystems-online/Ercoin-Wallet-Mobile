
import 'package:ercoin_wallet/interactor/registration_info/registration_info_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/utils/view/checkbox_with_text.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegistrationInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegistrationInfoState();
}

class _RegistrationInfoState extends State<RegistrationInfoPage> {
  bool _isAccepted = false;

  final _interactor = mainInjector.getDependency<RegistrationInfoInteractor>();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Account not registered"),
    ),
    body: TopAndBottomContainer(
      top: _registrationInfoLabel(),
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _registrationInfoCheckbox(),
          _proceedBtn()
        ],
      )
    )
  );


  Widget _registrationInfoLabel() => Column(
    children: <Widget>[
      const Text("The account is created but not registered in the blockchain. In order to register you have to transfer ercoins to it. Upon receiving first ercoins registration fee will be charged by the blockchain."),
      SizedBox(height: 8),
    ],
  );

  Widget _registrationInfoCheckbox() => CheckboxWithTextWidget(
      text: "Don't show this message again",
      value: _isAccepted,
      onChanged: (isChecked) => setState(() => _isAccepted = isChecked)
  );

  Widget _proceedBtn() => ExpandedRaisedTextButton(
    text: "Proceed",
    onPressed: () async {
     if(_isAccepted) {
       await _interactor.persistRegistrationInfoRejected();
     }
     resetRoute(Navigator.of(context), () => HomeRoute());
    }
  );
}