import 'package:ercoin_wallet/view/account/AccountScreen.dart';
import 'package:ercoin_wallet/view/account_info/account_info_page.dart';
import 'package:ercoin_wallet/view/address/AddressScreen.dart';
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
    TransactionScreen(),
    AddressScreen(),
    AccountScreen()
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text("Home view"),
        centerTitle: true,
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.blue,
        selectedItemColor: Colors.blueAccent,
        currentIndex: _selectedPageIndex,
        onTap: (int index) {
          setState(() => _selectedPageIndex = index);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.info),
              title: Text("Info")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text("Transactions")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervisor_account),
              title: Text("Addresses")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text("Accounts")
          )
        ],
      )
  );
}