import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:kyure/clipboard_utils.dart';
import 'package:kyure/presentation/widgets/molecules/copy_area.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/toast_widget.dart';

class AccountItemMolecule extends StatelessWidget {
  const AccountItemMolecule(
      {super.key,
      this.imageAsset,
      this.imagePath,
      this.imageUrl,
      required this.name,
      required this.username,
      required this.password,
      this.onTap});

  final String? imageAsset;
  final String? imagePath;
  final String? imageUrl;
  final String name;
  final String username;
  final String password;
  final Function()? onTap;

  copyUser(BuildContext context, Offset offset) {
    final kyTheme = KyTheme.of(context)!;
    ClipboardUtils.copy(username);
    BotToast.showCustomText(
      toastBuilder: (cancelFunc) => ToastWidgetMolecule(
        text: 'Copied!',
        prefix: const Icon(Icons.check),
        backgroundColor: kyTheme.colorToastBackground,
        textStyle: TextStyle(color: kyTheme.colorToastText),
      ),
    );
  }

  copyPassword(BuildContext context, Offset offset) {
    ClipboardUtils.copy(password);
    final kyTheme = KyTheme.of(context)!;
    BotToast.showCustomText(
        toastBuilder: (cancelFunc) => ToastWidgetMolecule(
              text: 'Copied!',
              prefix: const Icon(Icons.check),
              backgroundColor: kyTheme.colorToastBackground,
              textStyle: TextStyle(color: kyTheme.colorToastText),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    Image? image;
    if (imageAsset != null) {
      image = Image.asset(imageAsset!);
    } else if (imagePath != null) {
      image = Image.file(File(imageAsset!));
    } else if (imageUrl != null) {
      image = Image.network(imageUrl!);
    }

    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: 42,
                height: 42,
                child: image,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    username,
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(color: kyTheme.colorHint),
                  )
                ],
              ),
            ),
            CopyAreaMolecule(
              icon: Icon(
                Icons.person,
                color: kyTheme.colorAccount,
              ),
              color: kyTheme.colorAccount,
              onTap: (details) => copyUser(context, details.globalPosition),
            ),
            const SizedBox(width: 6),
            CopyAreaMolecule(
              icon: Icon(Icons.key_rounded, color: kyTheme.colorPassword),
              color: kyTheme.colorPassword,
              onTap: (details) => copyPassword(context, details.globalPosition),
            )
          ],
        ),
      ),
    );
  }
}
