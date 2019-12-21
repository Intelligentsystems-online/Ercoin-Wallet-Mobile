import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/home/page/account_info/account_info_page.dart';
import 'package:ercoin_wallet/view/home/page/account_list/account_list_page.dart';
import 'package:ercoin_wallet/view/home/page/address_book/address_book_page.dart';
import 'package:ercoin_wallet/view/home/page/transfer_list/transfer_list_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {

  final int initialPageIndex;

  const HomeRoute({this.initialPageIndex = 0});

  @override
  _HomeRouteState createState() => _HomeRouteState(initialPageIndex);
}

class _HomeRouteState extends State<HomeRoute> {
  int _currentPageIndex = 0;

  List<Widget> _pages;

  _HomeRouteState(int initialPageIndex) {
    _currentPageIndex = initialPageIndex;
  }

  @override
  initState() {
    _pages = [AccountInfoPage(_setCurrentPageIndex), TransferListPage(), AddressBookPage(), AccountListPage()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Ercoin wallet")),
        body: Container(
          padding: standardPadding.copyWith(bottom: 0.0),
          child: _pages[_currentPageIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).cardColor,
          showUnselectedLabels: true,
          selectedFontSize: 14.00,
          unselectedFontSize: 14.00,
          currentIndex: _currentPageIndex,
          onTap: (index) => setState(() => _currentPageIndex = index),
          items: [
            _navigationBarItem(Icons.home, "Home"),
            _navigationBarItem(Icons.history, "History"),
            _navigationBarItem(Icons.import_contacts, "Address book"),
            _navigationBarItem(Icons.account_circle, "Accounts")
          ],
        ),
      );

  BottomNavigationBarItem _navigationBarItem(IconData iconData, String text) =>
      BottomNavigationBarItem(icon: Icon(iconData), title: Text(text));

  _setCurrentPageIndex(int index) => setState(() => _currentPageIndex = index);
}
