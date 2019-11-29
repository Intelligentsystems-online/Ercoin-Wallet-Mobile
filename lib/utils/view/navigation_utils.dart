import 'package:flutter/material.dart';

pushRoute(NavigatorState navigator, Function() builder) => navigator.push(MaterialPageRoute(builder: (_) => builder()));

resetRoute(NavigatorState navigator, Function() builder) {
  navigator.popUntil((route) => route.isFirst);
  navigator.pushReplacement(MaterialPageRoute(builder: (_) => builder()));
}
