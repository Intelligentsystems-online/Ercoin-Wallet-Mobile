import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/local_account/local_account_activation_details.dart';
import 'package:ercoin_wallet/repository/local_account/local_account_repository.dart';
import 'package:ercoin_wallet/service/local_account/active/active_local_account_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_details_cache_service.dart';
import 'package:ercoin_wallet/service/local_account/local_account_service.dart';

class AccountDetailsInteractor {
  final ActiveLocalAccountService _activeAccountService;
  final LocalAccountService _accountService;
  final LocalAccountRepository _localAccountRepository;
  final LocalAccountDetailsCacheService _localAccountDetailsCacheService;

  const AccountDetailsInteractor(
      this._activeAccountService,
      this._accountService,
      this._localAccountRepository,
      this._localAccountDetailsCacheService);

  Future<LocalAccountActivationDetails> obtainAccountActivationDetails(LocalAccount account) async =>
      await _activeAccountService.obtainAccountActivationDetails(account);

  Future toggleAccountActivation(LocalAccountActivationDetails details) async =>
      await _activeAccountService.persistActiveAccount(
          details.isActive ? await _obtainAnyAccountExcept(details.details.localAccount) : details.details.localAccount
      );

  Future updateAccountByPublicKey(String publicKey, LocalAccount account) async {
    await _localAccountRepository.updateByPublicKey(publicKey, account);
    _localAccountDetailsCacheService.invalidateCache();
  }
  Future deleteAccountByPublicKey(String publicKey) async {
    await _localAccountRepository.deleteByPublicKey(publicKey);
    _localAccountDetailsCacheService.invalidateCache();
  }

  Future<LocalAccount> _obtainAnyAccountExcept(LocalAccount account) async {
    final accounts = await _accountService.obtainList();
    return accounts.firstWhere((element) => element != account);
  }
}
