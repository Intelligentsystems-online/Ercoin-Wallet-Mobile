import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/address/Address.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';

import 'package:flutter/cupertino.dart';

class AddressList extends StatelessWidget {
  final List<Address> addresses;
  final Function(Account) onAddressPressed;

  const AddressList({this.addresses, this.onAddressPressed});

  @override
  Widget build(BuildContext context) => ListView.builder(
      itemCount: addresses.length,
      itemBuilder: (context, index) => ExpandedRow(child: _prepareAddressRow(addresses[index]))
  );

  Widget _prepareAddressRow(Address address) => GestureDetector(
    onTap: () => onAddressPressed,
    child: Text(address.accountName)
  );
}