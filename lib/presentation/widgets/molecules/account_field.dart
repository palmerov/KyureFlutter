import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:kyure/clipboard_utils.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/copy_area.dart';
import 'package:kyure/presentation/widgets/molecules/toast_widget.dart';

class AccountFieldMolecule extends StatelessWidget {
  AccountFieldMolecule(
      {super.key,
      required this.editing,
      required this.accountField,
      this.nameEditable = true}) {
    controllerField = TextEditingController();
    controllerField.text = accountField.data;

    controllerLabel = editing ? TextEditingController() : null;
    if (controllerLabel != null) {
      controllerLabel!.text = accountField.name;
    }
  }
  final bool editing;
  final bool nameEditable;
  final AccountField accountField;
  late final TextEditingController controllerField;
  late final TextEditingController? controllerLabel;

  _copyData(BuildContext context) {
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
    String data = controllerField.text;
    String name = controllerLabel!.text;
    return AccountField(name: name, data: data, visible: accountField.visible);
  }

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    final field = TextFormField(
      readOnly: !editing,
      controller: controllerField,
      minLines: 1,
      maxLines: 100,
      keyboardType: accountField.visible
          ? TextInputType.text
          : TextInputType.visiblePassword,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(14),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              gapPadding: 4),
          labelText: !editing ? accountField.name : null,
          hintText: 'Value, password, key...',
          suffix: !editing
              ? CopyAreaMolecule(
                  icon: const Icon(Icons.copy_rounded),
                  color: kyTheme.colorHint,
                  onTap: (_) => _copyData(context),
                  padding: const EdgeInsets.all(0),
                  showBorder: false,
                )
              : null),
    );
    return editing
        ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextField(
                controller: controllerLabel,
                style: const TextStyle(fontSize: 15),
                decoration: const InputDecoration(
                    hintText: 'Field name',
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.all(4),
                    isDense: true
                    ),
              ),
            ),
            field
          ])
        : field;
  }
}
