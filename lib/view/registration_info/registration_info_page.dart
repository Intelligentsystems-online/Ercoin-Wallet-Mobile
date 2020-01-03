
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
      title: const Text("Registration info"),
    ),
    body: TopAndBottomContainer(
      top: _registrationInfoLabel(),
      bottom: _proceedBtn()
    )
  );

  Widget _registrationInfoLabel() => Column(
    children: <Widget>[
      const Text("Account is not registered in blockchain node. Therefore, an account retention fee will be charged on the first transfers"),
      _registrationInfoCheckbox()
    ],
  );

  Widget _registrationInfoCheckbox() => CheckboxWithTextWidget(
      text: "I understand, don't show again.",
      value: _isAccepted,
      onChanged: (isChecked) => setState(() => _isAccepted = isChecked)
  );

  Widget _proceedBtn() => ExpandedRaisedTextButton(
    text: "Procced",
    onPressed: () async {
     if(_isAccepted) {
       await _interactor.persistRegistrationInfoRejected();
     }
     resetRoute(Navigator.of(context), () => HomeRoute());
    }
  );

}