import 'dart:convert';
import 'dart:typed_data';

import 'package:ercoin_wallet/model/account_info.dart';
import 'package:ercoin_wallet/model/account_status.dart';
import 'package:ercoin_wallet/model/api_response.dart';
import 'package:ercoin_wallet/model/api_response_status.dart';
import 'package:ercoin_wallet/repository/account/Account.dart';

class CommonAccountUtil {
  AccountInfo obtainAccountInfoFrom(ApiResponse<String> apiResponse, Account account) {
    if(apiResponse.status == ApiResponseStatus.SUCCESS) {
      final accountBalance = _obtainBalanceValue(base64.decode(apiResponse.response));

      return AccountInfo(account, accountBalance, AccountStatus.REGISTERED);
    }
    else if(apiResponse.status == ApiResponseStatus.ACCOUNT_NOT_FOUND)
      return AccountInfo(account, 0.0, AccountStatus.NOT_REGISTERED);
    else
      return AccountInfo(account, 0.0, AccountStatus.REGISTERED);
  }

  double _obtainBalanceValue(Uint8List accountDataBytes) {
    ByteBuffer buffer = _balanceBytesFrom(accountDataBytes).buffer;
    int microErcoinAmount = ByteData
        .view(buffer)
        .getInt64(0);

    return _ridOfMicroPrefixFrom(microErcoinAmount);
  }

  List<AccountInfo> filterAccountsInfoBy(String value, List<AccountInfo> accounts) => accounts
      .where((account) => _contains(value, account))
      .toList();

  _contains(String value, AccountInfo account) => account
      .account
      .name
      .toLowerCase()
      .contains(value.toLowerCase());

  Uint8List _balanceBytesFrom(Uint8List accountDataBytes) => accountDataBytes.sublist(4, 12);

  double _ridOfMicroPrefixFrom(int amount) => amount / 1000000;
}