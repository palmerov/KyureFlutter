import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/clipboard_utils.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/presentation/widgets/atoms/any_image.dart';
import 'package:kyure/presentation/widgets/molecules/copy_area.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/image_rounded.dart';
import 'package:kyure/presentation/widgets/molecules/toast_widget.dart';
import 'package:kyure/services/service_locator.dart';

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
      final fields = getFieldList(true);
      if (fields.length == 1) {
        return copyValue(context, state, fields.first);
      }
      showCopyBottomSheet(context, state, fields);
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
      final fields = getFieldList(false);
      if (fields.length == 1) {
        return copyValue(context, state, fields.first);
      }
      showCopyBottomSheet(context, state, fields);
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

  List<AccountField> getFieldList(bool visible) {
    if (account.fieldList?.isNotEmpty ?? false) {
      return [
        visible ? account.fieldUsername : account.fieldPassword,
        ...account.fieldList!
            .where((element) =>
                element.visible == visible && element.data.isNotEmpty)
            .toList()
      ];
    } else {
      return visible ? [account.fieldUsername] : [account.fieldPassword];
    }
  }

  showCopyBottomSheet(BuildContext context, CopyAreaMoleculeState state,
      List<AccountField> fields) {
    final kyTheme = KyTheme.of(context)!;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Copiar el valor de:',
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: fields.length,
                    itemBuilder: (context, index) => FieldValueItem(
                        field: fields[index],
                        onTap: (field) {
                          copyValue(context, state, field);
                        })),
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
        image: account.image.path);

    return InkWell(
      onTap: onTap,
      onLongPress: onLongTap,
      onSecondaryTap: onLongTap,
      splashColor: kyTheme.colorPrimarySmooth,
      highlightColor: kyTheme.colorPrimarySmooth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
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
                  Text(
                    account.fieldUsername.data,
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(color: kyTheme.colorHint, fontWeight: FontWeight.w300),
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
      leading: SvgPicture.asset(
          widget.field.visible
              ? 'assets/svg_icons/badge_24dp_E8EAED_FILL0_wght300_GRAD0_opsz24.svg'
              : 'assets/svg_icons/key.svg',
          height: 30,
          width: 30,
          colorFilter: ColorFilter.mode(
              widget.field.visible
                  ? kyTheme.colorAccount
                  : kyTheme.colorPassword,
              BlendMode.srcIn)),
      title: Text(widget.field.name,
          style: const TextStyle(fontWeight: FontWeight.w400)),
      subtitle: Text(
          widget.field.visible || visible
              ? widget.field.data
              : widget.field.data.replaceAll(RegExp(r'.'), '*'),
          style: const TextStyle(fontWeight: FontWeight.w300)),
      trailing: !widget.field.visible
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
