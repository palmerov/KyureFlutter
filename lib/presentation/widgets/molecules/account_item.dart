import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kyure/clipboard_utils.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/presentation/widgets/molecules/copy_area.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/image_rounded.dart';
import 'package:kyure/presentation/widgets/molecules/toast_widget.dart';

class AccountItemMolecule extends StatelessWidget {
  const AccountItemMolecule(
      {super.key, required this.account, this.onTap, this.onLongTap});

  final Account account;
  final Function()? onTap;
  final Function()? onLongTap;

  copyUser(BuildContext context, Offset offset) {
    final kyTheme = KyTheme.of(context)!;
    ClipboardUtils.copy(account.fieldUsername.data);
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
    ClipboardUtils.copy(account.fieldPassword.data);
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
    image = Image.asset(account.image.path);

    return InkWell(
      onTap: onTap,
      onLongPress: onLongTap,
      onSecondaryTap: onLongTap,
      splashColor: kyTheme.colorPrimarySmooth,
      highlightColor: kyTheme.colorPrimarySmooth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
                tag: '@${account.id}:${account.name}',
                child: ImageRounded(image: image)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: TextStyle(
                        color: kyTheme.colorOnBackground,
                        fontWeight: FontWeight.w300,
                        fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    account.fieldUsername.data,
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(color: kyTheme.colorHint),
                  )
                ],
              ),
            ),
            CopyAreaMolecule(
              icon: SvgPicture.asset('assets/svg_icons/person.svg',
                  height: 30,
                  width: 30,
                  colorFilter:
                      ColorFilter.mode(kyTheme.colorAccount, BlendMode.srcIn)),
              padding: const EdgeInsets.all(8),
              color: kyTheme.colorAccount,
              onTap: (details) => copyUser(context, details.globalPosition),
            ),
            const SizedBox(width: 6),
            CopyAreaMolecule(
              icon: SvgPicture.asset('assets/svg_icons/key.svg',
                  height: 30,
                  width: 30,
                  colorFilter:
                      ColorFilter.mode(kyTheme.colorPassword, BlendMode.srcIn)),
              padding: const EdgeInsets.all(8),
              color: kyTheme.colorPassword,
              onTap: (details) => copyPassword(context, details.globalPosition),
            )
          ],
        ),
      ),
    );
  }
}
