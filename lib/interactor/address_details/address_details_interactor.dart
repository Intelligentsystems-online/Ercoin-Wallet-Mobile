import 'package:ercoin_wallet/repository/named_address/named_address_repository.dart';

class AddressDetailsInteractor {
  final NamedAddressRepository _namedAddressRepository;

  const AddressDetailsInteractor(this._namedAddressRepository);

  Future updateNameByPublicKey(String publicKey, String name) async =>
    await _namedAddressRepository.updateNameByPublicKey(publicKey, name);

  Future deleteAccountByPublicKey(String publicKey) async =>
    await _namedAddressRepository.deleteByPublicKey(publicKey);
}