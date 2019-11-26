import 'package:flutter/material.dart';

moveTo(BuildContext context, WidgetBuilder routeBuilder) =>
    Navigator.of(context).push(MaterialPageRoute(builder: routeBuilder));

runAfterBuild(Function() block) =>
    WidgetsBinding.instance.addPostFrameCallback((_) => block);
