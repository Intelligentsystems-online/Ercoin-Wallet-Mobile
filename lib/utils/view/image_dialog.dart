import 'package:flutter/cupertino.dart';

class ImageDialog extends StatelessWidget {
  final Widget _image;

  const ImageDialog(this._image);

  @override
  Widget build(BuildContext context) => GestureDetector(
    child: Center(
      child: _image,
    ),
    onTap: () => Navigator.pop(context)
  );
}