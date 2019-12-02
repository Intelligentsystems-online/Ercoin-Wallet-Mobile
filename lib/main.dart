import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/view/add_account/add_account_route.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:ercoin_wallet/view/terms/terms_route.dart';

import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final AccountRepository accountRepository = AccountRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: FutureBuilderWithProgress(
                future: accountRepository.findAll(),
                builder: (List<Account> accounts) {
                  return accounts.isEmpty ? _onNewUser() : HomeRoute();
                })));
  }

  Widget _onNewUser() => TermsRoute(
      onProceed: (ctx) => pushRoute(
          Navigator.of(ctx),
          () => AddAccountRoute(
                onAdded: (ctx) => resetRoute(Navigator.of(ctx), () => HomeRoute()),
              )));
}
