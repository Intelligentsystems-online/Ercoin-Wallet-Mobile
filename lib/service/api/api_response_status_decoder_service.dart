import 'package:ercoin_wallet/model/api/api_response_status.dart';

class ApiResponseStatusDecoderService {
  ApiResponseStatus accountCodeToStatus(int responseCode) {
    switch(responseCode) {
      case 0:
        return ApiResponseStatus.SUCCESS;
      case 2:
        return ApiResponseStatus.ACCOUNT_NOT_FOUND;
      default:
        return ApiResponseStatus.GENERIC_ERROR;
    }
  }

  ApiResponseStatus transferCodeToStatus(int responseCode) {
    switch(responseCode) {
      case 0:
        return ApiResponseStatus.SUCCESS;
      case 4:
        return ApiResponseStatus.INSUFFICIENT_FUNDS;
      default:
        return ApiResponseStatus.GENERIC_ERROR;
    }
  }

  ApiResponseStatus genericCodeToStatus(int responseCode) =>
      responseCode == 0 ? ApiResponseStatus.SUCCESS : ApiResponseStatus.GENERIC_ERROR;
}
