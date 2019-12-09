import 'package:ercoin_wallet/view/account/AccountScreen.dart';
import 'package:ercoin_wallet/view/address/AddressScreen.dart';
import 'package:ercoin_wallet/view/home/page/account_info/account_info_page.dart';
import 'package:ercoin_wallet/view/home/page/account_list/account_list_page.dart';
import 'package:ercoin_wallet/view/home/page/address_list/address_list_page.dart';
import 'package:ercoin_wallet/view/home/page/transaction_list/transaction_list_page.dart';
import 'package:ercoin_wallet/view/transaction/TransactionScreen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeRouteState();
}

class HomeRouteState extends State<HomeRoute> {
  int _selectedPageIndex = 0;

  final List<Widget> _pages = [
    AccountInfoPage(),
    TransactionListPage(),
    AddressListPage(),
    AccountListPage()
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text("Ercoin wallet"),
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).cardColor,
        showUnselectedLabels: true,
        selectedFontSize: 14.00,
        unselectedFontSize: 14.00,
        currentIndex: _selectedPageIndex,
        onTap: (index) => setState(() => _selectedPageIndex = index),
        items: [
          _navigationBarItem(Icons.info, "Info"),
          _navigationBarItem(Icons.list, "Transactions"),
          _navigationBarItem(Icons.supervisor_account, "Addresses"),
          _navigationBarItem(Icons.account_circle, "Accounts")
        ],
      )
  );

  BottomNavigationBarItem _navigationBarItem(IconData iconData, String text) => BottomNavigationBarItem(
      icon: Icon(iconData),
      title: Text(text)
  );
}
