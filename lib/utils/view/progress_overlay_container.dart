import 'package:flutter/material.dart';

class ProgressOverlayContainer extends StatelessWidget {
  final bool overlayEnabled;
  final Widget child;
  final double overlayOpacity;

  ProgressOverlayContainer({@required this.overlayEnabled, @required this.child, this.overlayOpacity = 0.2});

  @override
  Widget build(BuildContext context) => overlayEnabled ? _buildWithOverlay() : child;

  Widget _buildWithOverlay() => Stack(
        children: <Widget>[
          child,
          Positioned.fill(child: Container(color: Colors.black.withOpacity(overlayOpacity))),
          Center(child: CircularProgressIndicator())
        ],
      );
}
