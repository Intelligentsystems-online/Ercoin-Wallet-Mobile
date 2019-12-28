import 'package:ercoin_wallet/utils/view/standard_search_text_field.dart';
import 'package:flutter/material.dart';

class SearchableList extends StatelessWidget {
  final Function(String) onSearchChanged;
  final Widget listWidget;

  const SearchableList({this.onSearchChanged, this.listWidget});

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      StandardSearchTextField((value) => onSearchChanged(value)),
      const SizedBox(height: 8.0),
      Expanded(child: listWidget)
    ],
  );
}
