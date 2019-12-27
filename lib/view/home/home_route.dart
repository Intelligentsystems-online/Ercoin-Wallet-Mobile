import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/view/home/page/account_info/account_info_page.dart';
import 'package:ercoin_wallet/view/home/page/account_list/account_list_page.dart';
import 'package:ercoin_wallet/view/home/page/address_book/address_book_page.dart';
import 'package:ercoin_wallet/view/home/page/transfer_list/transfer_list_page.dart';
import 'package:ercoin_wallet/view/settings/settings_route.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {
  final int initialPageIndex;
  final String snackBarText;

  const HomeRoute({this.initialPageIndex = 0, this.snackBarText});

  @override
  _HomeRouteState createState() => _HomeRouteState(initialPageIndex, snackBarText);
}

class _HomeRouteState extends State<HomeRoute> {
  final String _snackBarText;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentPageIndex = 0;
  List<Widget> _pages;

  _HomeRouteState(int initialPageIndex, this._snackBarText) {
    _currentPageIndex = initialPageIndex;
  }

  @override
  initState() {
    super.initState();
    _pages = [AccountInfoPage(_setCurrentPageIndex), TransferListPage(), AddressBookPage(), AccountListPage()];
    if (_snackBarText != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showTextSnackBar(_scaffoldKey.currentState, _snackBarText));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
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
