import 'dart:io';

import 'package:ercoin_wallet/interactor/settings/settings_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/standard_copy_text_box.dart';
import 'package:ercoin_wallet/utils/view/standard_text_form_field.dart';
import 'package:ercoin_wallet/utils/view/top_and_bottom_container.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text("Settings")),
        body: FutureBuilderWithProgress(
          future: _interactor.obtainBackupDirectory(),
          builder: (Directory directory) => Container(
            padding: standardPadding,
            child: Form(
              key: _formKey,
              child: _settingsContent(directory.path),
            ),
          ),
        ),
      );

  Widget _settingsContent(String directoryBackupPath) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _contentText(),
          const SizedBox(height: 16.0),
          StandardTextFormField(
            hintText: "Node address",
            icon: const Icon(Icons.edit),
            controller: _nodeUriController,
            onFocusLost: () => _save(),
            validator: (_) => _nodeUriValidationResult,
            onSaved: (value) => setState(() => _nodeUri = value),
          ),
          const SizedBox(height: 16.0),
          StandardCopyTextBox(
            value: directoryBackupPath,
            labelText: "Backup path",
          ),
        ],
      );

  Widget _contentText() => RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Here you can configure and check application properties. If you want to change configuration using a non-default node, make sure you trust it. For more details see ",
              style: standardTextSpanStyle,
            ),
            TextSpan(
              text: "Official Ercoin Site. ",
              style: standardLinkTextSpanStyle,
              recognizer: TapGestureRecognizer()..onTap = () => launch('https://ercoin.tech/'),
            ),
          ],
        ),
      );

  _save() async {
    _formKey.currentState.save();
    await _validateNodeUri();
    if (_formKey.currentState.validate()) {
      await _interactor.persistNodeUri(_nodeUri);
    }
  }

  _validateNodeUri() async {
    final validationResult = await _interactor.validateNodeUri(_nodeUri);
    if (validationResult != null)
      setState(() => _nodeUriValidationResult = validationResult);
    else
      setState(() => _nodeUriValidationResult = null);
  }

  _loadNodeEndpointUri() async {
    final nodeEndpointUri = await _interactor.obtainNodeUri();
    _nodeUriController.text = nodeEndpointUri;
  }
}
