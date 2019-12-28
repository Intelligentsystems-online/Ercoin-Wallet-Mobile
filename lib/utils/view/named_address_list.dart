import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';

import 'package:flutter/material.dart';

class NamedAddressList extends StatelessWidget {
  final List<NamedAddress> namedAddressList;
  final List<LocalAccount> localAccountList;
  final Function(BuildContext, NamedAddress) onAddressPressed;

  const NamedAddressList({@required this.namedAddressList, @required this.onAddressPressed, this.localAccountList});

  @override
  Widget build(BuildContext ctx) {
    if(_obtainItemCount() > 0) {
      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _obtainItemCount(),
        itemBuilder: (context, index) => ExpandedRow(child: _listRowForIndex(ctx, index)),
      );
    } else {
      return const Center(child: const Text("Nothing to show"));
    }
  }

  Widget _listRowForIndex(BuildContext ctx, int index) {
    if(localAccountList != null && index < localAccountList.length) {
      return _listRow(ctx, localAccountList[index].namedAddress, isLocal: true);
    } else {
      return _listRow(ctx, namedAddressList[index - (localAccountList?.length ?? 0)], isLocal: false);
    }
  }

  Widget _listRow(BuildContext ctx, NamedAddress address, {bool isLocal}) => GestureDetector(
    onTap: () => onAddressPressed(ctx, address),
    child: Card(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
          leading: Icon(isLocal ? Icons.account_circle : Icons.person),
          title: Text(address.name),
          subtitle: isLocal ? const Text("Local account") : null,
      ),
    ),
  );

  _obtainItemCount() => namedAddressList.length + (localAccountList?.length ?? 0);
}
