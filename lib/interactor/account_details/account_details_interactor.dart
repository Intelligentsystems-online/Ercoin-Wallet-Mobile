import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/local_account/local_account_activation_details.dart';
import 'package:ercoin_wallet/service/local_account/active/active_local_account_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_service.dart';

class AccountDetailsInteractor {
  final ActiveLocalAccountService _activeAccountService;
  final LocalAccountService _accountService;

  const AccountDetailsInteractor(this._activeAccountService, this._accountService);

  Future<LocalAccountActivationDetails> obtainAccountActivationDetails(LocalAccount account) async =>
      await _activeAccountService.obtainAccountActivationDetails(account);

  Future toggleAccountActivation(LocalAccountActivationDetails details) async =>
      await _activeAccountService.persistActiveAccount(
          details.isActive ? await _obtainAnyAccountExcept(details.details.localAccount) : details.details.localAccount
      );

  Future<LocalAccount> _obtainAnyAccountExcept(LocalAccount account) async {
    final accounts = await _accountService.obtainList();
    return accounts.firstWhere((element) => element != account);
  }
}
