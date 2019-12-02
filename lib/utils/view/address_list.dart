import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressList extends StatelessWidget {
  final List<Address> addresses;
  final Function(BuildContext, Address) onAddressPressed;

  const AddressList(this.addresses, this.onAddressPressed);

  @override
  Widget build(BuildContext ctx) => ListView.builder(
      itemCount: addresses.length,
      itemBuilder: (context, index) => ExpandedRow(child: _addressRow(ctx, addresses[index]))
  );

  Widget _addressRow(BuildContext ctx, Address address) => GestureDetector(
    onTap: () => onAddressPressed(ctx, address),
    child: Card(
      child: Text(address.accountName)
    )
  );
}
