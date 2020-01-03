import 'package:ercoin_wallet/configuration/interactors_configuration.dart';
import 'package:ercoin_wallet/configuration/repositories_configuration.dart';
import 'package:ercoin_wallet/configuration/services_configuration.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/repository/local_account/local_account_repository.dart';
import 'package:ercoin_wallet/utils/view/future_builder_with_progress.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/add_account/add_account_route.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';
import 'package:ercoin_wallet/view/terms/terms_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injector/injector.dart';

final Injector mainInjector = Injector();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  RepositoriesConfiguration.configure(mainInjector);
  ServicesConfiguration.configure(mainInjector);
  InteractorsConfiguration.configure(mainInjector);

  await ServicesConfiguration.initialize(mainInjector);
  
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(App());
}

class App extends StatelessWidget {
  final _localAccountRepository = mainInjector.getDependency<LocalAccountRepository>();

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: FutureBuilderWithProgress(
            future: _localAccountRepository.findAll(),
            builder: (List<LocalAccount> accounts) {
              return accounts.isEmpty ? _onNewUser() : HomeRoute();
            },
          ),
        ),
        theme: standardThemeData,
      );

  Widget _onNewUser() => TermsRoute(
      onProceed: (ctx) => pushRoute(Navigator.of(ctx), () => AddAccountRoute())
  );
}
