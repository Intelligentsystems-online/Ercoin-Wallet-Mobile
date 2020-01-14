import 'package:ercoin_wallet/model/base/address.dart';
import 'package:ercoin_wallet/model/local_account/local_account.dart';
import 'package:ercoin_wallet/utils/qr_icon.dart';
import 'package:ercoin_wallet/utils/view/image_dialog.dart';
import 'package:ercoin_wallet/utils/view/values.dart';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddressQrCode extends StatelessWidget {

  final Address address;

  const AddressQrCode({@required this.address});

  @override
  Widget build(BuildContext ctx) => IconButton(
    icon: const Icon(QRIcon.qrcode, size: 48.0),
    onPressed: () => _onPressed(ctx),
  );

  _onPressed(BuildContext ctx) =>
      showDialog(context: ctx, builder: (ctx) => ImageDialog(_qrCode(300.0)));

  Widget _qrCode(double size) => QrImage(
      data: address.base58,
      size: size,
      padding: standardPadding,
  );
}
