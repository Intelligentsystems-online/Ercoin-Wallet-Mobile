import 'package:ercoin_wallet/interactor/interactor_configuration.dart';
import 'dart:ui';

import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/account/local_account_repository.dart';
import 'package:ercoin_wallet/repository/repository_configuration.dart';
import 'package:ercoin_wallet/utils/service/service_utils_configuration.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/add_account/add_account_route.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:ercoin_wallet/view/terms/terms_route.dart';

import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

final Injector mainInjector = Injector();

void main() async {
  await RepositoryConfiguration.configure(mainInjector);
  ServiceUtilsConfiguration.configure(mainInjector);
  InteractorConfiguration.configure(mainInjector);

  runApp(App());
}

class App extends StatelessWidget {
  final _accountRepository = mainInjector.getDependency<LocalAccountRepository>();

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: FutureBuilderWithProgress(
            future: _accountRepository.findAll(),
            builder: (List<Account> accounts) {
              return accounts.isEmpty ? _onNewUser() : HomeRoute();
            },
          ),
        ),
        theme: standardThemeData,
      );

  Widget _onNewUser() => TermsRoute(
        onProceed: (ctx) => pushRoute(
          Navigator.of(ctx),
          () => AddAccountRoute(
            onAdded: (ctx) => resetRoute(Navigator.of(ctx), () => HomeRoute()),
          ),
        ),
      );
}
