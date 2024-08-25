import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/clipboard_utils.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/data/utils/url_utils.dart';
import 'package:kyure/main.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/account_field_type_icon.dart';
import 'package:kyure/presentation/widgets/molecules/autocomplete_password_generator.dart';
import 'package:kyure/presentation/widgets/molecules/copy_area.dart';
import 'package:kyure/presentation/widgets/molecules/toast_widget.dart';
import 'package:kyure/utils/extensions.dart';
import 'package:kyure/utils/extensions_classes.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:random_password_generator/random_password_generator.dart';

class AccountFieldMolecule extends StatefulWidget {
  const AccountFieldMolecule(
      {super.key,
      required this.editing,
      required this.accountField,
      this.nameEditable = true,
      this.onTapDelete,
      this.onFieldChanged,
      required this.onCopy,
      required this.isTypeEditable});

  final Function() onCopy;
  final bool editing;
  final bool nameEditable;
  final AccountField accountField;
  final bool isTypeEditable;
  final Function()? onTapDelete;
  final Function(String name, String data, AccountFieldType type)?
      onFieldChanged;

  @override
  State<AccountFieldMolecule> createState() => _AccountFieldMoleculeState();
}

class _AccountFieldMoleculeState extends State<AccountFieldMolecule> {
  bool obscureText = false;
  TextEditingController? controllerField;
  TextEditingController? controllerLabel;
  AccountFieldType type = AccountFieldType.text;

  @override
  void initState() {
    super.initState();
    obscureText = widget.accountField.isPassword;
    type = widget.accountField.type;
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
    widget.onCopy();
  }

  AccountField getEditingData() {
    String data = controllerField!.text;
    String name = controllerLabel!.text;
    return AccountField(name: name, data: data, type: type);
  }

  Widget getFieldWidget(BuildContext context, KyTheme kyTheme) {
    Widget field;
    if (widget.editing && widget.accountField.isPassword) {
      field = AutocompletePasswordGenerator(
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
          controllerField = textEditingController;
          controllerField!.text = widget.accountField.data;
          return _buildTextField(kyTheme, focusNode);
        },
        onPasswordGenerated: (password) {
          controllerField!.text = password;
          widget.onFieldChanged?.call(controllerLabel!.text, password, type);
        },
        key: UniqueKey(),
      );
    } else {
      controllerField = TextEditingController(text: widget.accountField.data);
      controllerField!.text = widget.accountField.data;
      field = _buildTextField(kyTheme, null);
    }
    return field;
  }

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    controllerLabel = TextEditingController(text: widget.accountField.name);
    controllerLabel!.text = widget.accountField.name;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: TextFormField(
              onChanged: (value) => widget.onFieldChanged?.call(
                  controllerLabel!.text,
                  controllerField!.text,
                  widget.accountField.type),
              controller: controllerLabel,
              textAlignVertical: TextAlignVertical.center,
              readOnly: !widget.editing,
              style: TextStyle(fontSize: 14, color: kyTheme.colorHint),
              decoration: InputDecoration(
                  hintText: 'Field name',
                  border:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                  contentPadding:
                      isPC ? const EdgeInsets.all(4) : const EdgeInsets.all(1),
                  isDense: true)),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: getFieldWidget(context, kyTheme)),
            if (!widget.editing || widget.onTapDelete != null)
              Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: CopyAreaMolecule(
                    icon: Icon(
                        widget.editing ? CupertinoIcons.delete : Icons.copy,
                        size: 20,
                        color: widget.editing
                            ? widget.onTapDelete != null
                                ? Colors.red
                                : kyTheme.colorHint
                            : kyTheme.colorPassword),
                    animate: !widget.editing,
                    padding: const EdgeInsets.all(8),
                    color: kyTheme.colorPassword,
                    onTap: widget.editing && widget.onTapDelete == null
                        ? null
                        : (_, __) {
                            if (!widget.editing) {
                              _copyData(context);
                            } else {
                              widget.onTapDelete!();
                            }
                          },
                  ))
          ],
        )
      ],
    );
  }

  TextInputType getTextInputType(AccountFieldType type) {
    switch (type) {
      case AccountFieldType.text:
        return TextInputType.text;
      case AccountFieldType.password:
        return TextInputType.visiblePassword;
      case AccountFieldType.url:
        return TextInputType.url;
      case AccountFieldType.phone:
        return TextInputType.phone;
      case AccountFieldType.email:
        return TextInputType.emailAddress;
      case AccountFieldType.number:
        return TextInputType.number;
      case AccountFieldType.qr:
        return TextInputType.multiline;
    }
  }

  updateObscureText() {
    obscureText = type == AccountFieldType.password && !widget.editing;
  }

  void _showAccountFieldTypeChooserDialog(BuildContext context) {
    context.showOptionListDialog(
        'Tipo de campo', const Icon(CupertinoIcons.textbox), [
      Option('Texto', const Icon(CupertinoIcons.textformat, size: 20), () {
        updateObscureText();
        setState(() => type = AccountFieldType.text);
        widget.onFieldChanged
            ?.call(controllerLabel!.text, controllerField!.text, type);
        context.pop();
      }),
      Option('Contraseña', const Icon(CupertinoIcons.lock, size: 20), () {
        updateObscureText();
        setState(() => type = AccountFieldType.password);
        widget.onFieldChanged
            ?.call(controllerLabel!.text, controllerField!.text, type);
        context.pop();
      }),
      Option('Email', const Icon(CupertinoIcons.mail, size: 20), () {
        updateObscureText();
        setState(() => type = AccountFieldType.email);
        widget.onFieldChanged
            ?.call(controllerLabel!.text, controllerField!.text, type);
        context.pop();
      }),
      Option('Link', const Icon(CupertinoIcons.link, size: 20), () {
        updateObscureText();
        setState(() => type = AccountFieldType.url);
        widget.onFieldChanged
            ?.call(controllerLabel!.text, controllerField!.text, type);
        context.pop();
      }),
      Option('Teléfono', const Icon(CupertinoIcons.phone, size: 20), () {
        updateObscureText();
        setState(() => type = AccountFieldType.phone);
        widget.onFieldChanged
            ?.call(controllerLabel!.text, controllerField!.text, type);
        context.pop();
      }),
      Option('Número', const Icon(CupertinoIcons.number, size: 20), () {
        updateObscureText();
        setState(() => type = AccountFieldType.number);
        widget.onFieldChanged
            ?.call(controllerLabel!.text, controllerField!.text, type);
        context.pop();
      }),
      Option('QR', const Icon(CupertinoIcons.qrcode, size: 20), () {
        updateObscureText();
        setState(() => type = AccountFieldType.qr);
        widget.onFieldChanged
            ?.call(controllerLabel!.text, controllerField!.text, type);
        context.pop();
      })
    ]);
  }

  Widget? _buildSuffixIcon(BuildContext context, KyTheme kyTheme) {
    if (widget.editing) {
      if (widget.isTypeEditable) {
        return AccountFieldIconButtonMolecule(
            type: type,
            color: kyTheme.colorOnBackgroundOpacity60,
            onPressed: () => _showAccountFieldTypeChooserDialog(context));
      }
      return null;
    } else {
      switch (type) {
        case AccountFieldType.password:
          return AccountFieldIconButtonMolecule(
              color: kyTheme.colorOnBackgroundOpacity60,
              onPressed: () => setState(() {
                    obscureText = !obscureText;
                    if (widget.editing) {
                      widget.onFieldChanged?.call(
                          controllerLabel!.text, controllerField!.text, type);
                    }
                  }),
              icon:
                  obscureText ? CupertinoIcons.eye : CupertinoIcons.eye_slash);
        case AccountFieldType.url:
          return AccountFieldIconButtonMolecule(
              color: kyTheme.colorOnBackgroundOpacity60,
              icon: Icons.open_in_new_rounded,
              onPressed: () => launchAnyURL(widget.accountField.data));
        case AccountFieldType.qr:
          return null;
        default:
          return AccountFieldIconButtonMolecule(
              color: kyTheme.colorOnBackgroundOpacity60,
              icon: CupertinoIcons.qrcode,
              onPressed: () => context.showQRDialog(
                  widget.accountField.data, widget.accountField.name));
      }
    }
  }

  int getMaxLineCount(){
    if(widget.accountField.isPassword || obscureText){
      return 1;
    }
    switch(type){
      case AccountFieldType.url:
      case AccountFieldType.phone:
      case AccountFieldType.email:
        return 1;
      case AccountFieldType.password:
        return 1;
      case AccountFieldType.text:
      case AccountFieldType.number:
      case AccountFieldType.qr:
        return 100;
    }
  }

  Widget _buildTextField(KyTheme kyTheme, FocusNode? focusNode) {
    if (type == AccountFieldType.qr && !widget.editing) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kyTheme.colorOnBackgroundOpacity30),
            color: Colors.white),
        padding: const EdgeInsets.all(4),
        child: QrImageView(data: widget.accountField.data, size: 200),
      );
    }
    return TextFormField(
      focusNode: focusNode,
      onChanged: (value) => widget.onFieldChanged
          ?.call(controllerLabel!.text, controllerField!.text, type),
      readOnly: !widget.editing,
      controller: controllerField,
      minLines: 1,
      maxLines: getMaxLineCount(),
      style: TextStyle(
          color: widget.editing
              ? kyTheme.colorOnBackground
              : kyTheme.colorOnBackgroundOpacity80),
      keyboardType: getTextInputType(type),
      obscureText: obscureText && !widget.editing,
      decoration: InputDecoration(
        suffixIcon: _buildSuffixIcon(context, kyTheme),
        contentPadding: const EdgeInsets.all(14),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 1.5,
                color: widget.editing
                    ? kyTheme.colorPrimary
                    : kyTheme.colorSeparatorLine),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            gapPadding: 4),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: widget.editing
                    ? kyTheme.colorOnBackgroundOpacity50
                    : kyTheme.colorSeparatorLine),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            gapPadding: 4),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: widget.editing
                    ? kyTheme.colorOnBackgroundOpacity50
                    : kyTheme.colorSeparatorLine),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            gapPadding: 4),
        hintText: 'Value, password, key...',
      ),
    );
  }
}
