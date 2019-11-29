import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';

import 'package:flutter/cupertino.dart';

class AddressList extends StatelessWidget {
  final List<Address> addresses;

  const AddressList({this.addresses});

  @override
  Widget build(BuildContext context) => ListView.builder(
      itemCount: addresses.length,
      itemBuilder: (context, index) =>  ExpandedRow(child: Text(addresses[index].accountName))
  );
}