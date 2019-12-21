import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/service/named_address/named_address_service.dart';

class AddAddressIntractor {
  final NamedAddressService _namedAddressService;

  const AddAddressIntractor(this._namedAddressService);

  Future addAddress(Address address, String name) async {
    await _namedAddressService.create(address, name);
  }
}
