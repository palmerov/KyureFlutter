import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kyure/clipboard_utils.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/copy_area.dart';
import 'package:kyure/presentation/widgets/molecules/toast_widget.dart';
import 'package:random_password_generator/random_password_generator.dart';

class AccountFieldMolecule extends StatefulWidget {
  AccountFieldMolecule(
      {super.key,
      required this.editting,
      required this.accountField,
      this.nameEditable = true,
      this.onTapDelete,
      this.onFieldChanged});
  final bool editting;
  final bool nameEditable;
  final AccountField accountField;
  final Function()? onTapDelete;
  final Function(String name, String data, bool visible)? onFieldChanged;

  @override
  State<AccountFieldMolecule> createState() => _AccountFieldMoleculeState();
}

class _AccountFieldMoleculeState extends State<AccountFieldMolecule> {
  bool visible = true;
  TextEditingController? controllerField;
  TextEditingController? controllerLabel;
  late RandomPasswordGenerator passwordGenerator;

  @override
  void initState() {
    super.initState();
    visible = widget.accountField.visible;
    passwordGenerator = RandomPasswordGenerator();
  }

  void _copyData(BuildContext context) {
    ClipboardUtils.copy(widget.accountField.data);
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
    return AccountField(
        name: name, data: data, visible: widget.accountField.visible);
  }

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    Widget field;
    if (widget.editting && !visible) {
      controllerLabel = TextEditingController(text: widget.accountField.name);
      controllerLabel!.text = widget.accountField.name;
      field = Autocomplete<String>(
          optionsViewBuilder: (context, Function(String) onSelected, options) {
        if (options.isEmpty) return const SizedBox.shrink();
        return Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: SizedBox(
                width: 280,
                child: Material(
                  child: InkWell(
                    onTap: () => onSelected(options.first),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.lock,
                              size: 20, color: kyTheme.colorPassword),
                          const SizedBox(width: 8),
                          Text(options.first,
                              style: TextStyle(
                                  fontSize: 16, color: kyTheme.colorPassword)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
      }, fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
        controllerField = textEditingController;
        controllerField!.text = widget.accountField.data;
        return _buildTextField(kyTheme, focusNode);
      }, displayStringForOption: (option) {
        final text = passwordGenerator.randomPassword(
            letters: true,
            numbers: true,
            specialChar: true,
            uppercase: true,
            passwordLength: 16);
        widget.onFieldChanged?.call(controllerLabel!.text, text, visible);
        return text;
      }, optionsBuilder: (textEditingValue) {
        return textEditingValue.text.isEmpty
            ? ['Generar contraseña segura']
            : [];
      });
    } else {
      controllerField = TextEditingController(text: widget.accountField.data);
      controllerField!.text = widget.accountField.data;
      controllerLabel = TextEditingController(text: widget.accountField.name);
      controllerLabel!.text = widget.accountField.name;
      field = _buildTextField(kyTheme, null);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: TextFormField(
            onChanged: (value) => widget.onFieldChanged?.call(
                controllerLabel!.text,
                controllerField!.text,
                widget.accountField.visible),
            controller: controllerLabel,
            textAlignVertical: TextAlignVertical.center,
            readOnly: !widget.editting,
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
            if (!widget.editting || widget.onTapDelete != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: CopyAreaMolecule(
                  icon:
                      Icon(widget.editting ? CupertinoIcons.delete : Icons.copy,
                          size: 20,
                          color: widget.editting
                              ? widget.onTapDelete != null
                                  ? Colors.red
                                  : kyTheme.colorHint
                              : kyTheme.colorPassword),
                  animate: !widget.editting,
                  padding: const EdgeInsets.all(8),
                  color: kyTheme.colorPassword,
                  onTap: widget.editting && widget.onTapDelete == null
                      ? null
                      : (_) {
                          if (!widget.editting) {
                            _copyData(context);
                          } else {
                            widget.onTapDelete!();
                          }
                        },
                ),
              )
          ],
        )
      ],
    );
  }

  TextFormField _buildTextField(KyTheme kyTheme, FocusNode? focusNode) {
    return TextFormField(
      focusNode: focusNode,
      onChanged: (value) => widget.onFieldChanged?.call(controllerLabel!.text,
          controllerField!.text, widget.accountField.visible),
      readOnly: !widget.editting,
      controller: controllerField,
      minLines: 1,
      maxLines: widget.accountField.visible ? 100 : 1,
      style: TextStyle(
          color: widget.editting
              ? kyTheme.colorOnBackground
              : kyTheme.colorOnBackgroundOpacity80),
      keyboardType: widget.accountField.visible
          ? TextInputType.text
          : TextInputType.visiblePassword,
      obscureText: !visible && !widget.editting,
      decoration: InputDecoration(
        suffixIcon: !widget.accountField.visible || widget.editting
            ? InkWell(
                onTap: () {
                  setState(() {
                    visible = !visible;
                    if (widget.editting) {
                      widget.onFieldChanged?.call(controllerLabel!.text,
                          controllerField!.text, visible);
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                      size: 20,
                      widget.editting
                          ? (visible
                              ? CupertinoIcons.lock_open
                              : CupertinoIcons.lock)
                          : (visible
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash),
                      color: kyTheme.colorOnBackgroundOpacity60),
                ),
              )
            : null,
        contentPadding: const EdgeInsets.all(14),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 1.5,
                color: widget.editting
                    ? kyTheme.colorPrimary
                    : kyTheme.colorSeparatorLine),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            gapPadding: 4),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: widget.editting
                    ? kyTheme.colorOnBackgroundOpacity60
                    : kyTheme.colorSeparatorLine),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            gapPadding: 4),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: widget.editting
                    ? kyTheme.colorOnBackgroundOpacity60
                    : kyTheme.colorSeparatorLine),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            gapPadding: 4),
        hintText: 'Value, password, key...',
      ),
    );
  }
}
