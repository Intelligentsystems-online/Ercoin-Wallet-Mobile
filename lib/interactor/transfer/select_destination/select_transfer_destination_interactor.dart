import 'dart:async';

import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/base/named_address.dart';
import 'package:ercoin_wallet/service/named_address/named_address_service.dart';


class SelectTransferDestinationInteractor {
  final NamedAddressService _namedAddressService;

  SelectTransferDestinationInteractor(this._namedAddressService);

  Future<List<NamedAddress>> obtainNamedAddressList() => _namedAddressService.obtainList();

  Future<NamedAddress> createNamedAddress(Address address, String name) => _namedAddressService.create(address, name);

  Future<List<NamedAddress>> obtainNamedAddressListByNameContains(String name) => _namedAddressService.obtainListByNameContains(name);
}
