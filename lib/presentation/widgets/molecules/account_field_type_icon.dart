import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/models/vault_data.dart';

class AccountFieldIconButtonMolecule extends StatelessWidget {
  final AccountFieldType? type;
  final Color? color;
  final IconData? icon;
  final Function()? onPressed;
  final double? size;

  const AccountFieldIconButtonMolecule(
      {super.key, this.type, this.color, this.onPressed, this.icon, this.size});

  IconData getIcon() {
    switch (type) {
      case AccountFieldType.text:
        return CupertinoIcons.textbox;
      case AccountFieldType.password:
        return CupertinoIcons.padlock;
      case AccountFieldType.number:
        return CupertinoIcons.number;
      case AccountFieldType.url:
        return CupertinoIcons.link;
      case AccountFieldType.email:
        return CupertinoIcons.mail;
      case AccountFieldType.phone:
        return CupertinoIcons.phone;
      case AccountFieldType.qr:
        return CupertinoIcons.qrcode;
      default:
        return CupertinoIcons.textbox;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(icon ?? getIcon(), size: size ?? 20, color: color),
        onPressed: onPressed);
  }
}
