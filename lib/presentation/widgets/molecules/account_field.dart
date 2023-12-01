import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kyure/clipboard_utils.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/copy_area.dart';
import 'package:kyure/presentation/widgets/molecules/toast_widget.dart';

class AccountFieldMolecule extends StatelessWidget {
  AccountFieldMolecule(
      {super.key,
      required this.editting,
      required this.accountField,
      this.nameEditable = true,
      this.onTapDelete,
      TextEditingController? controllerField,
      TextEditingController? controllerLabel,
      this.onFieldChanged})
      : controllerField = controllerField ?? TextEditingController(),
        controllerLabel = controllerLabel ?? TextEditingController() {
    this.controllerField!.text = accountField.data;
    this.controllerLabel!.text = accountField.name;
  }
  final bool editting;
  final bool nameEditable;
  final AccountField accountField;
  final TextEditingController? controllerField;
  final TextEditingController? controllerLabel;
  final Function()? onTapDelete;
  final Function(String name, String data)? onFieldChanged;

  void _copyData(BuildContext context) {
    ClipboardUtils.copy(accountField.data);
    final kyTheme = KyTheme.of(context)!;
    BotToast.showCustomText(
        toastBuilder: (cancelFunc) => ToastWidgetMolecule(
              text: 'Copied!',
              prefix: const Icon(Icons.check),
              backgroundColor: kyTheme.colorToastBackground,
              textStyle: TextStyle(color: kyTheme.colorToastText),
            ));
  }

  AccountField getEditingData() {
    String data = controllerField!.text;
    String name = controllerLabel!.text;
    return AccountField(name: name, data: data, visible: accountField.visible);
  }

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    final field = TextFormField(
      onChanged: (value) => onFieldChanged?.call(
          controllerLabel!.text, controllerField!.text),
      readOnly: !editting,
      controller: controllerField,
      minLines: 1,
      maxLines: 100,
      style: TextStyle(
          color: editting
              ? kyTheme.colorOnBackground
              : kyTheme.colorOnBackgroundOpacity80),
      keyboardType: accountField.visible
          ? TextInputType.text
          : TextInputType.visiblePassword,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(14),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 1.5,
                color: editting
                    ? kyTheme.colorPrimary
                    : kyTheme.colorSeparatorLine),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            gapPadding: 4),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: editting
                    ? kyTheme.colorOnBackgroundOpacity60
                    : kyTheme.colorSeparatorLine),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            gapPadding: 4),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: editting
                    ? kyTheme.colorOnBackgroundOpacity60
                    : kyTheme.colorSeparatorLine),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            gapPadding: 4),
        hintText: 'Value, password, key...',
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: TextFormField(
            onChanged: (value) => onFieldChanged?.call(
                controllerLabel!.text, controllerField!.text),
            controller: controllerLabel,
            textAlignVertical: TextAlignVertical.center,
            readOnly: !editting,
            style: const TextStyle(fontSize: 15),
            decoration: const InputDecoration(
                hintText: 'Field name',
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.all(2),
                isDense: true),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: field),
            if (!editting || onTapDelete != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: CopyAreaMolecule(
                  icon: Icon(editting ? CupertinoIcons.delete : Icons.copy,
                      size: 20,
                      color: editting
                          ? onTapDelete != null
                              ? Colors.red
                              : kyTheme.colorHint
                          : kyTheme.colorPassword),
                  animate: !editting,
                  padding: const EdgeInsets.all(8),
                  color: kyTheme.colorPassword,
                  onTap: editting && onTapDelete == null
                      ? null
                      : (_) {
                          if (!editting) {
                            _copyData(context);
                          } else {
                            onTapDelete!();
                          }
                        },
                ),
              )
          ],
        )
      ],
    );
  }
}
