import 'package:ercoin_wallet/utils/view/standard_text_field.dart';
import 'package:flutter/cupertino.dart';

class SearchableList extends StatelessWidget {
  final Function(String) onSearchChanged;
  final Widget listWidget;

  const SearchableList({this.onSearchChanged, this.listWidget});

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      StandardTextField((value) => onSearchChanged(value)),
      Flexible(child: listWidget)
    ],
  );
}