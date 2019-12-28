import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/view/home/page/account_info/account_info_page.dart';
import 'package:ercoin_wallet/view/home/page/account_list/account_list_page.dart';
import 'package:ercoin_wallet/view/home/page/address_book/address_book_page.dart';
import 'package:ercoin_wallet/view/home/page/transfer_list/transfer_list_page.dart';
import 'package:ercoin_wallet/view/settings/settings_route.dart';


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
  PageController _pageController;

  int _currentPageIndex = 0;

  _HomeRouteState(int initialPageIndex, this._snackBarText) {
    _currentPageIndex = initialPageIndex;
    _pageController = PageController(initialPage: initialPageIndex, keepPage: true);
  }

  @override
  initState() {
    super.initState();
    if (_snackBarText != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showTextSnackBar(_scaffoldKey.currentState, _snackBarText));
    }
  }

  @override
  Widget build(BuildContext ctx) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text("Ercoin wallet"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              disabledColor: Colors.white,
              onPressed: () => pushRoute(Navigator.of(ctx), () => SettingsRoute()),
            )
          ],
        ),
        body: _pageView(),
        bottomNavigationBar: _bottomNavigationBar(ctx),
      );

  Widget _pageView() => PageView(
    controller: _pageController,
    onPageChanged: (index) => setState(() => _currentPageIndex = index),
    children: <Widget>[AccountInfoPage(), TransferListPage(), AddressBookPage(), AccountListPage()],
  );

  Widget _bottomNavigationBar(BuildContext context) => BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Theme.of(context).cardColor,
    showUnselectedLabels: true,
    selectedFontSize: 14.00,
    unselectedFontSize: 14.00,
    currentIndex: _currentPageIndex,
    onTap: (index) {
      setState(() => _currentPageIndex = index);
      _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    },
    items: [
      _navigationBarItem(Icons.home, "Home"),
      _navigationBarItem(Icons.history, "History"),
      _navigationBarItem(Icons.import_contacts, "Address book"),
      _navigationBarItem(Icons.account_circle, "Accounts")
    ],
  );

  BottomNavigationBarItem _navigationBarItem(IconData iconData, String text) =>
      BottomNavigationBarItem(icon: Icon(iconData), title: Text(text));
}
