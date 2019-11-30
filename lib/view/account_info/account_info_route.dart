import 'package:ercoin_wallet/interactor/account_info/account_info_interctor.dart';
import 'package:ercoin_wallet/model/account_with_balance.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/view/add_account/add_account_route.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:flutter/cupertino.dart';

class AccountInfoRoute extends StatelessWidget {
  final _interactor = AccountInfoInteractor(); //TODO(DI)

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: _interactor.activeAccountWithBalance(),
      builder: (context, snapshot) => snapshot.hasData ? _accountInfoView(snapshot.data) : _onNoAccountFound()
  );

  Widget _accountInfoView(AccountWithBalance accountWithBalance) => Container(
    child: Column(
      children: <Widget>[
        Text("Account: " + accountWithBalance.account.accountName),
        Text("Balance: " + accountWithBalance.balance.toString() + " MICRO ERCOIN"),
      ],
    ),
  );


  Widget _onNoAccountFound() => AddAccountRoute(
    onAdded: (ctx) => resetRoute(Navigator.of(ctx), () => HomeRoute()),
  );
}