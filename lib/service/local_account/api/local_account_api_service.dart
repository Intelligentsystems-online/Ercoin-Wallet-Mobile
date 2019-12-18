import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/model/local_account/local_account_details.dart';
import 'package:ercoin_wallet/service/api/api_consumer_service.dart';
import 'package:ercoin_wallet/service/local_account/api/local_account_details_decoding_service.dart';

class LocalAccountApiService {
  final ApiConsumerService _apiConsumerService;
  final LocalAccountDetailsDecodingService _detailsUtil;

  const LocalAccountApiService(this._apiConsumerService, this._detailsUtil);

  Future<LocalAccountDetails> obtainAccountDetails(LocalAccount account) async {
    final response = await _apiConsumerService.fetchAccountDataBase64For(account.namedAddress.address);
    return _detailsUtil.buildAccountDetails(response, account);
  }


}
