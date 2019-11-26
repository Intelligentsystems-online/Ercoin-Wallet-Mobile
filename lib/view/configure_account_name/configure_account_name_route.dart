import 'package:ercoin_wallet/utils/progress_overlay_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sodium/flutter_sodium.dart';

class ConfigureAccountNameRoute extends StatefulWidget {
  final WidgetBuilder afterCreated;
  final KeyPair keyPair;

  ConfigureAccountNameRoute({@required this.afterCreated, @required this.keyPair});
}

class _ConfigureAccountNameRouteState extends State<ConfigureAccountNameRoute> {
  final WidgetBuilder afterCreated;
  final KeyPair keyPair;

  String _accountName = "";
  bool _isLoading = false;

  _ConfigureAccountNameRouteState(this.afterCreated, this.keyPair);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Configure account name"),
    ),
    body: ProgressOverlayContainer(
      overlayEnabled: _isLoading,
      
    )
  );
}
