import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/view/home/page/account_info/account_info_page.dart';
import 'package:ercoin_wallet/view/home/page/account_list/account_list_page.dart';
import 'package:ercoin_wallet/view/home/page/address_book/address_book_page.dart';
import 'package:ercoin_wallet/view/home/page/transfer_list/transfer_list_page.dart';
import 'package:ercoin_wallet/view/settings/settings_route.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {
  int initialPageIndex;

  HomeRoute({this.initialPageIndex}) {
    if(initialPageIndex == null)
      initialPageIndex = 0;
  }

  @override
  State<StatefulWidget> createState() => HomeRouteState(this.initialPageIndex);
}

class HomeRouteState extends State<HomeRoute> {
  int _selectedPageIndex;

  HomeRouteState(this._selectedPageIndex);

  final List<Widget> _pages = [
    AccountInfoPage(),
    TransferListPage(),
    AddressBookPage(),
    AccountListPage()
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text("Ercoin wallet"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            disabledColor: Colors.white,
            onPressed: () => pushRoute(Navigator.of(context), () => SettingsRoute()),
          )
        ],
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
          _navigationBarItem(Icons.home, "Home"),
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
