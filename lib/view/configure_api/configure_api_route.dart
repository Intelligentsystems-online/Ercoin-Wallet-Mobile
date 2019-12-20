import 'package:ercoin_wallet/interactor/configure_api/configure_api_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/standard_text_form_field.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfigureApiRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ConfigureApiState();
}

class _ConfigureApiState extends State<ConfigureApiRoute> {
  String _nodeEndpointUri;

  final _interactor = mainInjector.getDependency<ConfigureApiInteractor>();

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
        child: Column(
          children: <Widget>[_nodeUriInput()],
        ),
      ),
      bottom: _proceedBtn(),
    )
  );

  Widget _nodeUriInput() => ExpandedRow(
    child: StandardTextFormField(
      hintText: "Node endpoint",
      controller: _nodeUriController,
      validator: (value) => _interactor.validateNodeUri(value),
      onSaved: (value) => setState(() => _nodeEndpointUri = value)
    ),
  );

  Widget _proceedBtn() => ExpandedRaisedTextButton(
    text: "Proceed",
    onPressed: () => _onProceed(),
  );

  _onProceed() async {
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await _interactor.persistNodeUri(_nodeEndpointUri);
      pushRoute(Navigator.of(context), () => HomeRoute());
    }
  }

  _loadNodeEndpointUri() async {
    final nodeEndpointUri = await _interactor.obtainNodeUri();
    _nodeUriController.text = nodeEndpointUri;
  }
}