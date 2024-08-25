import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/clipboard_utils.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/data/utils/url_utils.dart';
import 'package:kyure/presentation/widgets/atoms/any_image.dart';
import 'package:kyure/presentation/widgets/molecules/account_field_type_icon.dart';
import 'package:kyure/presentation/widgets/molecules/copy_area.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/image_rounded.dart';
import 'package:kyure/presentation/widgets/molecules/toast_widget.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:kyure/utils/extensions.dart';

class AccountItemMolecule extends StatelessWidget {
  const AccountItemMolecule(
      {super.key, required this.account, this.onTap, this.onLongTap});

  final Account account;
  final Function()? onTap;
  final Function()? onLongTap;

  copyValue(
      BuildContext context, CopyAreaMoleculeState state, AccountField? field) {
    final kyTheme = KyTheme.of(context)!;
    if (field == null) {
      final fields = account.fieldsToCopy(false);
      if (fields.length == 1) {
        return copyValue(context, state, fields.first);
      }
      showValuesBottomSheet(
          context: context,
          fields: fields,
          title: 'Copiar valor',
          onTap: (field) => copyValue(context, state, field));
      return;
    }
    ClipboardUtils.copy(field.data);
    state.setCopiedState();
    BotToast.showCustomText(
      toastBuilder: (cancelFunc) => ToastWidgetMolecule(
        text: 'Copiado: ${field.name}',
        prefix: const Icon(Icons.check),
        backgroundColor: kyTheme.colorToastBackground,
        textStyle: TextStyle(color: kyTheme.colorToastText),
      ),
    );
    serviceLocator.getKiureService().addToRecents(account);
  }

  copyPassword(
      BuildContext context, CopyAreaMoleculeState state, AccountField? field) {
    if (field == null) {
      final fields = account.fieldsToCopy(true);
      if (fields.length == 1) {
        return copyValue(context, state, fields.first);
      }
      showValuesBottomSheet(
          context: context,
          fields: fields,
          title: 'Copiar clave',
          onTap: (field) => copyValue(context, state, field));
      return;
    }
    final kyTheme = KyTheme.of(context)!;
    ClipboardUtils.copy(field.data);
    state.setCopiedState();
    BotToast.showCustomText(
        toastBuilder: (cancelFunc) => ToastWidgetMolecule(
              text: 'Copiado: ${field.name}',
              prefix: const Icon(Icons.check),
              backgroundColor: kyTheme.colorToastBackground,
              textStyle: TextStyle(color: kyTheme.colorToastText),
            ));
    serviceLocator.getKiureService().addToRecents(account);
  }

  showQR(BuildContext context) {
    final fields = account.fieldsByType(AccountFieldType.qr);
    if (fields.isEmpty) return;
    if (fields.length == 1) {
      context.showQRDialog(fields.first.data, fields.first.name, true);
      return;
    }
    showValuesBottomSheet(
        context: context,
        fields: fields,
        title: 'Mostrar QR',
        onTap: (field) => context.showQRDialog(field.data, field.name, true));
  }

  launchURL(BuildContext context) {
    final fields = account.fieldsByType(AccountFieldType.url);
    if (fields.isEmpty) return;
    if (fields.length == 1) {
      launchAnyURL(fields.first.data);
      return;
    }
    showValuesBottomSheet(
        context: context,
        fields: fields,
        title: 'Abrir URL',
        onTap: (field) => launchAnyURL(field.data));
  }

  showValuesBottomSheet({
    required BuildContext context,
    required List<AccountField> fields,
    required Function(AccountField field) onTap,
    required String title,
  }) {
    if (fields.isEmpty) {
      showModalBottomSheet(
          context: context,
          builder: (context) => const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No hay valores para mostrar',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                          textAlign: TextAlign.center),
                    ]),
              ));
      return;
    }
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: fields.length,
                        itemBuilder: (context, index) => FieldValueItem(
                            field: fields[index],
                            onTap: (field) {
                              context.pop();
                              onTap(field);
                            })))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    Widget? image = AnyImage(
        source: AnyImageSource.fromJson(account.image.source.toJson()),
        image: account.image.data);
    return InkWell(
      onTap: onTap,
      onLongPress: onLongTap,
      onSecondaryTap: onLongTap,
      splashColor: kyTheme.colorPrimarySmooth,
      highlightColor: kyTheme.colorPrimarySmooth,
      mouseCursor: SystemMouseCursors.basic,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => showQR(context),
              mouseCursor: account.firstFieldByType(AccountFieldType.qr) == null
                  ? SystemMouseCursors.basic
                  : null,
              child: Stack(children: [
                Hero(
                    tag: '@${account.id}:${account.name}',
                    child: ImageRounded(image: image)),
                if (account.firstFieldByType(AccountFieldType.qr) != null)
                  Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            color: kyTheme.colorBackground.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.all(0.5),
                        child: Icon(CupertinoIcons.qrcode,
                            size: 14,
                            color: kyTheme.colorOnBackgroundOpacity80),
                      ))
              ]),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (account.firstFieldByType(AccountFieldType.url) != null)
                    InkWell(
                      onTap: () => launchURL(context),
                      borderRadius: BorderRadius.circular(8),
                      child: RichText(
                          text: TextSpan(
                              text: account.name,
                              style: TextStyle(
                                  color: kyTheme.colorPrimary,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18),
                              children: [
                            WidgetSpan(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 2, bottom: 2),
                              child: Transform.rotate(
                                angle: -pi / 4,
                                child: Icon(Icons.link,
                                    size: 14, color: kyTheme.colorPrimary),
                              ),
                            ))
                          ])),
                    ),
                  if (account.firstFieldByType(AccountFieldType.url) == null)
                    Text(account.name,
                        style: TextStyle(
                            color: kyTheme.colorOnBackground,
                            fontWeight: FontWeight.w300,
                            fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(
                    account.fieldUsername.data,
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        color: kyTheme.colorHint, fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
            CopyAreaMolecule(
              icon: SvgPicture.asset(
                  'assets/svg_icons/badge_24dp_E8EAED_FILL0_wght300_GRAD0_opsz24.svg',
                  height: 36,
                  width: 36,
                  colorFilter:
                      ColorFilter.mode(kyTheme.colorAccount, BlendMode.srcIn)),
              padding: const EdgeInsets.all(8),
              color: kyTheme.colorAccount,
              onTap: (details, state) => copyValue(context, state, null),
              instantCopy: false,
            ),
            const SizedBox(width: 8),
            CopyAreaMolecule(
              icon: SvgPicture.asset('assets/svg_icons/key.svg',
                  height: 36,
                  width: 36,
                  colorFilter:
                      ColorFilter.mode(kyTheme.colorPassword, BlendMode.srcIn)),
              padding: const EdgeInsets.all(8),
              color: kyTheme.colorPassword,
              instantCopy: false,
              onTap: (details, state) => copyPassword(context, state, null),
            )
          ],
        ),
      ),
    );
  }
}

class FieldValueItem extends StatefulWidget {
  const FieldValueItem({super.key, required this.field, required this.onTap});

  final AccountField field;
  final Function(AccountField field) onTap;

  @override
  State<FieldValueItem> createState() => _FieldValueItemState();
}

class _FieldValueItemState extends State<FieldValueItem> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      horizontalTitleGap: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      leading:
          AccountFieldIconButtonMolecule(type: widget.field.type, size: 28),
      title: Text(widget.field.name,
          style: const TextStyle(fontWeight: FontWeight.w400)),
      subtitle: Text(
          !widget.field.isPassword || visible
              ? widget.field.data
              : widget.field.data.replaceAll(RegExp(r'.'), '*'),
          style: const TextStyle(fontWeight: FontWeight.w300)),
      trailing: widget.field.isPassword
          ? IconButton(
              icon: Icon(!visible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
              onPressed: () => setState(() => visible = !visible))
          : null,
      onTap: () => widget.onTap(widget.field),
    );
  }
}
