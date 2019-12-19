import 'dart:async';

import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/service/named_address/named_address_service.dart';

class AddressBookInteractor {
  final NamedAddressService _namedAddressService;

  AddressBookInteractor(this._namedAddressService);

  Future<List<NamedAddress>> obtainNamedAddressList() => _namedAddressService.obtainList();

  Future<NamedAddress> createNamedAddress(Address address, String name) => _namedAddressService.create(address, name);

  Future<List<NamedAddress>> obtainNamedAddressListByNameContains(String value) =>  _namedAddressService.obtainListByNameContains(value);
}
