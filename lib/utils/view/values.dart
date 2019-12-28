import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const standardPadding = const EdgeInsets.all(8.0);
const standardDialogPadding = const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0);
const standardColumnSpacing = const EdgeInsets.symmetric(vertical: 5.0);
const standardBorderRadius = const BorderRadius.all(const Radius.circular(9.0));

const standardTextFieldContentPadding = const EdgeInsets.symmetric(vertical: 17, horizontal: 10);
const standardTextFieldLabelFontSize = 16.0;
const standardTextFieldBorder = const OutlineInputBorder(borderRadius: standardBorderRadius, borderSide: BorderSide());

final standardThemeData = ThemeData(
  brightness: Brightness.light,
  accentColor: Colors.indigoAccent,
  primarySwatch: Colors.indigo,
  buttonTheme: const ButtonThemeData(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
    shape: const StadiumBorder(),
    textTheme: ButtonTextTheme.primary,
  ),
  fontFamily: 'Montserrat',
  textTheme: TextTheme(body1: TextStyle(fontSize: 16.0)),
);
