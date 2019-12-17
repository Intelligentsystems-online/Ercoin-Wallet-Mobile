import 'package:ercoin_wallet/model/api/api_response_status.dart';

class ApiResponse<T> {
  final ApiResponseStatus status;
  final T response;

  const ApiResponse(this.status, this.response);
}
