import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

moveTo(BuildContext context, WidgetBuilder routeBuilder) =>
    Navigator.of(context).push(MaterialPageRoute(builder: routeBuilder));

runAfterBuild(Function() block) =>
    WidgetsBinding.instance.addPostFrameCallback((_) => block);
