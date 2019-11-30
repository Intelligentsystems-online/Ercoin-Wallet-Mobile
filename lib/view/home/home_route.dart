import 'package:ercoin_wallet/interactor/home/home_interactor.dart';
import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/view/account/AccountScreen.dart';
import 'package:ercoin_wallet/view/add_account/add_account_route.dart';
import 'package:ercoin_wallet/view/address/AddressScreen.dart';
import 'package:ercoin_wallet/view/transaction/TransactionScreen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeRouteState();
}

class HomeRouteState extends State<HomeRoute> {

  final _interactor = HomeInteractor(); // TODO(DI)

  int _selectedPage = 0;

  final List<Widget> _pages = [
    TransactionScreen(),
    AddressScreen(),
    AccountScreen()
  ];

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: _interactor.activeAccountWithBalance(),
      builder: (context, snapshot) => snapshot.hasData ? _homeView(context, snapshot.data) : _onNoAccountFound()
  );

  Scaffold _homeView(BuildContext context, AccountWithBalance accountWithBalance) => Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.blue,
        selectedItemColor: Colors.blueAccent,
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() => _selectedPage = index);
        },
        items: [
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

  Widget _onNoAccountFound() => AddAccountRoute(
    onAdded: (ctx) => resetRoute(Navigator.of(ctx), () => HomeRoute()),
  );
}