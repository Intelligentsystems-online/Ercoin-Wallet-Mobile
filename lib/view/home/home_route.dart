import 'package:ercoin_wallet/interactor/home/home_interactor.dart';
import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/utils/view/expanded_raised_text_button.dart';
import 'package:ercoin_wallet/utils/view/expanded_row.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/view/account/AccountScreen.dart';
import 'package:ercoin_wallet/view/add_account/add_account_route.dart';
import 'package:ercoin_wallet/view/address/AddressScreen.dart';
import 'package:ercoin_wallet/view/sendTransaction/SendTransactionScreen.dart';
import 'package:ercoin_wallet/view/transaction/TransactionScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatelessWidget {

  final _interactor = HomeInteractor(); // TODO(DI)

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: _interactor.activeAccountWithBalance(),
      builder: (context, snapshot) => snapshot.hasData ? _homeView(context, snapshot.data) : _onNoAccountFound()
  );

  Scaffold _homeView(BuildContext context, AccountWithBalance accountWithBalance) => Scaffold(
    appBar: AppBar(
      title: Text("Welcome " + accountWithBalance.account.accountName),
      centerTitle: true,
    ),
    body: Column(
      children: <Widget>[
        ExpandedRow(child: Text("Balance: " + accountWithBalance.balance.toString())),
        _sendBtn(context),
        _transactionsBtn(context),
        _accountsBtn(context),
        _addressesBtn(context)
      ],
    ),
  );
//
  Widget _sendBtn(BuildContext context) => ExpandedRaisedTextButton(
    text: "Send",
    onPressed: () => pushRoute(Navigator.of(context), () => SendTransactionScreen())
        //_navigateTo(context, SendTransactionScreen()),
  );

  Widget _transactionsBtn(BuildContext context) => ExpandedRaisedTextButton(
    text: "Transactions",
    onPressed: () => pushRoute(Navigator.of(context), () => TransactionScreen())
        //_navigateTo(context, TransactionScreen()),
  );

  Widget _accountsBtn(BuildContext context) => ExpandedRaisedTextButton(
    text: "My accounts",
    onPressed: () => pushRoute(Navigator.of(context), () => AccountScreen())
  );

  Widget _addressesBtn(BuildContext context) => ExpandedRaisedTextButton(
    text: "Address book",
    onPressed: () => pushRoute(Navigator.of(context), () => AddressScreen())
  );

  Widget _onNoAccountFound() => AddAccountRoute(
    onAdded: (ctx) => resetRoute(Navigator.of(ctx), () => HomeRoute()),
  );
}