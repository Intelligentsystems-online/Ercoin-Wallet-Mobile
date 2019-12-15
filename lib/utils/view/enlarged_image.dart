import 'package:flutter/cupertino.dart';

class EnlargedImage extends StatelessWidget {
  final Widget _image;

  const EnlargedImage(this._image);

  @override
  Widget build(BuildContext context) => GestureDetector(
    child: Center(
      child: _image,
    ),
    onTap: () => Navigator.pop(context)
  );
}