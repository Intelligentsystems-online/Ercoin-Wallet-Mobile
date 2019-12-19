import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NamedAddressList extends StatelessWidget {
  final List<NamedAddress> namedAddressList;
  final Function(BuildContext, NamedAddress) onAddressPressed;

  const NamedAddressList({this.namedAddressList, this.onAddressPressed});

  @override
  Widget build(BuildContext ctx) => ListView.builder(
      itemCount: namedAddressList.length,
      itemBuilder: (context, index) => ExpandedRow(child: _addressRow(ctx, namedAddressList[index]))
  );

  Widget _addressRow(BuildContext ctx, NamedAddress address) => GestureDetector(
    onTap: () => onAddressPressed(ctx, address),
    child: Card(
      child: ListTile(
        leading: Icon(Icons.person, color: Colors.blue),
        title: Text(address.name)
      ),
    )
  );
}
