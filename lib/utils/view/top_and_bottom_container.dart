import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:flutter/cupertino.dart';

class TopAndBottomContainer extends StatelessWidget {
  final Widget top;
  final Alignment topAlignment;
  final Widget bottom;
  final Alignment bottomAlignment;
  final EdgeInsetsGeometry padding;

  const TopAndBottomContainer({
    @required this.top,
    @required this.bottom,
    this.topAlignment = FractionalOffset.topCenter,
    this.bottomAlignment = FractionalOffset.bottomCenter,
    this.padding = standardPadding
  });

  @override
  Widget build(BuildContext ctx) => Container(
        padding: padding,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: topAlignment,
              child: top,
            ),
            Align(
              alignment: bottomAlignment,
              child: bottom,
            )
          ],
        ),
      );
}
