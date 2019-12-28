import 'package:flutter/material.dart';

class ProgressOverlayContainer extends StatelessWidget {
  final bool overlayEnabled;
  final Widget child;
  final double overlayOpacity;

  ProgressOverlayContainer({@required this.overlayEnabled, @required this.child, this.overlayOpacity = 1.0});

  @override
  Widget build(BuildContext ctx) => overlayEnabled ? _buildWithOverlay(ctx) : child;

  Widget _buildWithOverlay(BuildContext ctx) => Stack(
        children: <Widget>[
          child,
          Positioned.fill(child: Container(color: Theme.of(ctx).canvasColor.withOpacity(overlayOpacity))),
          Center(child: CircularProgressIndicator())
        ],
      );
}
