import 'package:ercoin_wallet/interactor/settings/settings_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/standard_text_form_field.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsRoute> {
  String _nodeUri;
  String _nodeUriValidationResult;

  final _interactor = mainInjector.getDependency<SettingsInteractor>();

  final _formKey = GlobalKey<FormState>();
  final _nodeUriController = TextEditingController();

  @override
  void initState() {
    _loadNodeEndpointUri();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Api configure"),
    ),
    body: TopAndBottomContainer(
      top: Form(
        key: _formKey,
        child: _nodeUriInput(),
      ),
      bottom: _proceedBtn(),
    )
  );

  Widget _nodeUriInput() => ExpandedRow(
    child: StandardTextFormField(
      hintText: "Node endpoint",
      controller: _nodeUriController,
      validator: (_) => _nodeUriValidationResult,
      onSaved: (value) => setState(() => _nodeUri = value)
    ),
  );

  Widget _proceedBtn() => ExpandedRaisedTextButton(
    text: "Proceed",
    onPressed: () => _onProceed(),
  );

  _onProceed() async {
    _formKey.currentState.save();
    await _validateNodeUri();
    if(_formKey.currentState.validate()) {
      await _interactor.persistNodeUri(_nodeUri);
      pushRoute(Navigator.of(context), () => HomeRoute());
    }
  }

  _validateNodeUri() async {
    final validationResult = await _interactor.validateNodeUri(_nodeUri);
    if(validationResult != null)
      setState(() => _nodeUriValidationResult = validationResult);
    else
      setState(() => _nodeUriValidationResult = null);
  }

  _loadNodeEndpointUri() async {
    final nodeEndpointUri = await _interactor.obtainNodeUri();
    _nodeUriController.text = nodeEndpointUri;
  }
}