import 'package:ercoin_wallet/interactor/interactor_configuration.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';
import 'package:ercoin_wallet/repository/account/AccountRepository.dart';
import 'package:ercoin_wallet/repository/repository_configuration.dart';
import 'package:ercoin_wallet/utils/service/account/account_utils_configuration.dart';
import 'package:ercoin_wallet/utils/service/api/api_utils_configuration.dart';
import 'package:ercoin_wallet/utils/service/common/common_utils_configuration.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/view/add_account/add_account_route.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:ercoin_wallet/view/terms/terms_route.dart';

import 'package:flutter/material.dart';

void main() {
  final _repositoryConfiguration = RepositoryConfiguration();
  final _commonUtilsConfiguration = CommonUtilsConfiguration();
  final _apiUtilsConfiguration = ApiUtilsConfiguration();
  final _accountUtilsConfiguration = AccountUtilsConfiguration();
  final _interactorConfiguration = InteractorConfiguration();

  _repositoryConfiguration.configure();
  _commonUtilsConfiguration.configure();
  _apiUtilsConfiguration.configure();
  _accountUtilsConfiguration.configure();
  _interactorConfiguration.configure();

  runApp(App());
}

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
