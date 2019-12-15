import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const standardPadding = const EdgeInsets.all(8.0);
const standardColumnSpacing = const EdgeInsets.symmetric(vertical: 5.0);
const standardBorderRadius = const BorderRadius.all(const Radius.circular(7));

const standardTextFieldContentPadding = const EdgeInsets.symmetric(vertical: 17, horizontal: 10);
const standardTextFieldLabelFontSize = 16.0;
const standardTextFieldBorder = const OutlineInputBorder(borderRadius: standardBorderRadius, borderSide: BorderSide());

const standardSnackBarDuration = const Duration(seconds: 2);

final standardThemeData = ThemeData(
  brightness: Brightness.light,
  accentColor: Colors.indigoAccent,
  primarySwatch: Colors.indigo,
  buttonTheme: const ButtonThemeData(
    shape: const RoundedRectangleBorder(borderRadius: standardBorderRadius),
    textTheme: ButtonTextTheme.primary,
  ),
  fontFamily: 'Montserrat',
);
