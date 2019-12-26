import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final Widget _image;

  const ImageDialog(this._image);

  @override
  Widget build(BuildContext context) => Dialog(
    child: GestureDetector(
        child: _image,
        onTap: () => Navigator.pop(context)
    )
  );
}
