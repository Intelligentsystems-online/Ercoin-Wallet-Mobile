import 'package:ercoin_wallet/interactor/account_list/account_list_interactor.dart';
import 'package:ercoin_wallet/main.dart';
import 'package:ercoin_wallet/model/local_account/local_account_activation_details.dart';
import 'package:ercoin_wallet/utils/view/account_list.dart';
import 'package:ercoin_wallet/utils/view/navigation_utils.dart';
import 'package:ercoin_wallet/utils/view/refreshable_future_builder.dart';
import 'package:ercoin_wallet/utils/view/searchable_list.dart';
import 'package:ercoin_wallet/utils/view/values.dart';
import 'package:ercoin_wallet/view/add_account/add_account_route.dart';
import 'package:ercoin_wallet/view/home/home_route.dart';

import 'package:flutter/material.dart';

class AccountListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  final _interactor = mainInjector.getDependency<AccountListInteractor>();
  final _builderKey = GlobalKey<RefreshableFutureBuilderState>();

  String _search;

  @override
  Widget build(BuildContext ctx) => Scaffold(
        body: Container(
          padding: standardPadding.copyWith(bottom: 0),
          child: RefreshableFutureBuilder<List<LocalAccountActivationDetails>>(
            key: _builderKey,
            forceScrollable: false,
            futureBuilder: (isRefresh) async => await _interactor.obtainDetailsList(_search, refresh: isRefresh),
            builder: (_, detailsList) => _accountList(detailsList),
          ),
        ),
        floatingActionButton: _addAccountBtn(ctx),
      );

  Widget _accountList(List<LocalAccountActivationDetails> detailsList) => SearchableList(
        onSearchChanged: (value) {
          setState(() => _search = value);
          _builderKey.currentState.update(isRefresh: false);
        },
        listWidget: AccountList(
          list: detailsList,
          afterBackFromAccountDetails: (_) => _builderKey.currentState.update(isRefresh: true),
        ),
      );

  FloatingActionButton _addAccountBtn(BuildContext ctx) => FloatingActionButton(
        heroTag: "AccountListPage",
        child: const Icon(Icons.add),
        onPressed: () => pushRoute(
          Navigator.of(ctx),
          () => AddAccountRoute(onAdded: (ctx) => resetRoute(Navigator.of(ctx), () => HomeRoute())),
        ),
      );
}
