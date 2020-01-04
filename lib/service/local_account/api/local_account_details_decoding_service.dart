import 'dart:convert';
import 'dart:typed_data';

import 'package:ercoin_wallet/model/api/api_response.dart';
import 'package:ercoin_wallet/model/api/api_response_status.dart';
import 'package:ercoin_wallet/model/base/coins_amount.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/local_account/local_account_details.dart';

class LocalAccountDetailsDecodingService {
  LocalAccountDetails buildAccountDetails(ApiResponse<String> apiResponse, LocalAccount account) {
    switch(apiResponse.status) {
      case ApiResponseStatus.SUCCESS:
        return LocalAccountDetails.of(
          localAccount: account,
          balance: _obtainBalanceValue(base64.decode(apiResponse.response)),
          isRegistered: true,
        );
      case ApiResponseStatus.ACCOUNT_NOT_FOUND:
        return LocalAccountDetails.of(
          localAccount: account,
          balance: CoinsAmount.ofErcoin(0.0),
          isRegistered: false,
        );
      default:
        throw Exception("Invalid API response");
    }
  }

  CoinsAmount _obtainBalanceValue(Uint8List accountDataBytes) {
    final buffer = _obtainBalanceBytes(accountDataBytes).buffer;
    final microErcoinAmount = ByteData
        .view(buffer)
        .getInt64(0);

    return CoinsAmount.ofMicroErcoin(microErcoinAmount);
  }

  Uint8List _obtainBalanceBytes(Uint8List accountDataBytes) => accountDataBytes.sublist(4, 12);
}
