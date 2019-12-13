import 'package:ercoin_wallet/model/api_response_status.dart';

class CodeMapperUtil {
  ApiResponseStatus accountCodeToStatus(int responseCode) {
    if(responseCode == 0)
      return ApiResponseStatus.SUCCESS;
    else if(responseCode == 2)
      return ApiResponseStatus.ACCOUNT_NOT_FOUND;
    else
      return ApiResponseStatus.FAILURE;
  }

  ApiResponseStatus transferCodeToStatus(int responseCode) {
    if(responseCode == 0)
      return ApiResponseStatus.SUCCESS;
    else if(responseCode == 4)
      return ApiResponseStatus.INSUFFICIENT_FUNDS;
    else
      return ApiResponseStatus.FAILURE;
  }

  ApiResponseStatus genericCodeToStatus(int responseCode) =>
      responseCode == 0 ? ApiResponseStatus.SUCCESS : ApiResponseStatus.FAILURE;
}