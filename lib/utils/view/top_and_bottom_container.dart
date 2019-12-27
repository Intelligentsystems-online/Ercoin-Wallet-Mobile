import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/material.dart';


class TopAndBottomContainer extends StatelessWidget {
  final Widget top;
  final Alignment topAlignment;
  final Widget bottom;
  final Alignment bottomAlignment;
  final EdgeInsetsGeometry padding;

  const TopAndBottomContainer({
    this.top,
    this.bottom,
    this.topAlignment = FractionalOffset.topCenter,
    this.bottomAlignment = FractionalOffset.bottomCenter,
    this.padding = standardPadding
  });

  @override
  Widget build(BuildContext ctx) => Container(
        padding: padding,
        child: Stack(
          children: <Widget>[
            if(top != null) Align(
              alignment: topAlignment,
              child: top,
            ),
            if(bottom != null) Align(
              alignment: bottomAlignment,
              child: bottom,
            )
          ],
        ),
      );
}
