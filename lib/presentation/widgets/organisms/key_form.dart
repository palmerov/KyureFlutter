import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kyure/main.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/atoms/page_body_constraint.dart';
import 'package:vibration/vibration.dart';

class KeyFormOrganism extends StatefulWidget {
  const KeyFormOrganism(
      {super.key,
      this.title,
      this.onBackgroundColor = Colors.white,
      required this.onTapEnter,
      required this.obscureText});

  final String? title;
  final Color onBackgroundColor;
  final Future<Widget?> Function(String key) onTapEnter;
  final bool obscureText;

  @override
  State<KeyFormOrganism> createState() => _KeyFormOrganismState();
}

class _KeyFormOrganismState extends State<KeyFormOrganism> {
  bool keyboard = false;
  late final TextEditingController controller;
  Widget? message;
  bool loading = false;
  final FocusNode _focusNode = FocusNode();
  double buttonHeight = 60;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      if (isPC) {
        keyboard = true;
        _focusNode.requestFocus();
      }
    });
  }

  void vibrate() {
    if (Platform.isAndroid || Platform.isIOS) {
      Vibration.vibrate(duration: 80);
    }
  }

  void submit() async {
    setState(() {
      loading = true;
    });
    vibrate();
    String text = controller.text;
    message = await widget.onTapEnter(text);
    if (message == null) controller.text = '';
    if (message != null) {
      if (Platform.isAndroid || Platform.isIOS) {
        Vibration.vibrate(duration: 200);
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final ktheme = KyTheme.of(context)!;
    buttonHeight = max(screenSize.height * 0.36 * 0.25, 70);
    return PageBodyConstraintAtom(
      child: Padding(
          padding: const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.title != null)
                  Text(
                    widget.title!,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: widget.onBackgroundColor, fontSize: 16),
                  ),
                const SizedBox(height: 16),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                        onFieldSubmitted: (value) => submit(),
                        focusNode: _focusNode,
                        controller: controller,
                        obscureText: widget.obscureText,
                        autofocus: keyboard,
                        readOnly: loading,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: widget.onBackgroundColor, fontSize: 18),
                        canRequestFocus: Platform.isLinux ||
                            Platform.isWindows ||
                            Platform.isMacOS ||
                            keyboard,
                        cursorColor: widget.onBackgroundColor,
                        decoration: InputDecoration(
                          fillColor: widget.onBackgroundColor.withOpacity(0.02),
                            filled: true,
                            contentPadding: EdgeInsets.only(
                                left: isMobile ? 48 : 0,
                                right: 0,
                                top: 16,
                                bottom: 16),
                            suffixIcon: loading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 16, top: 8, bottom: 8),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        color: widget.onBackgroundColor,
                                      ),
                                    ))
                                : isMobile
                                    ? Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: InkWell(
                                            onTap: () {
                                              setState(
                                                  () => keyboard = !keyboard);
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 100), () {
                                                if (keyboard) {
                                                  _focusNode.requestFocus();
                                                }
                                              });
                                            },
                                            child: Icon(
                                                !keyboard
                                                    ? CupertinoIcons.keyboard
                                                    : CupertinoIcons.number,
                                                color: widget.onBackgroundColor)))
                                    : null,
                            hintText: 'Llave de cifrado',
                            hintStyle: TextStyle(
                                color: widget.onBackgroundColor.withOpacity(0.4)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: widget.onBackgroundColor.withOpacity(0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: widget.onBackgroundColor.withOpacity(0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: widget.onBackgroundColor.withOpacity(0.2)),
                            )))),
                message != null
                    ? Padding(padding: const EdgeInsets.all(4), child: Center(child: message))
                    : const SizedBox(height: 8),
                if (keyboard || isPC)
                  isPC ? const SizedBox(height: 200) : const SizedBox(height: 0),
                if (!keyboard && isMobile)
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withAlpha(30),
                              borderRadius: BorderRadius.circular(16)),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                    height: buttonHeight,
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          KeyButton(
                                              onBackgroundColor:
                                                  widget.onBackgroundColor,
                                              text: '1',
                                              onTap: (text, icon) {
                                                controller.text += text!;
                                              }),
                                          KeyButton(
                                              onBackgroundColor:
                                                  widget.onBackgroundColor,
                                              text: '2',
                                              onTap: (text, icon) {
                                                controller.text += text!;
                                              }),
                                          KeyButton(
                                              onBackgroundColor:
                                                  widget.onBackgroundColor,
                                              text: '3',
                                              onTap: (text, icon) {
                                                controller.text += text!;
                                              })
                                        ])),
                                SizedBox(
                                    height: buttonHeight,
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          KeyButton(
                                              onBackgroundColor:
                                                  widget.onBackgroundColor,
                                              text: '4',
                                              onTap: (text, icon) {
                                                controller.text += text!;
                                              }),
                                          KeyButton(
                                              onBackgroundColor:
                                                  widget.onBackgroundColor,
                                              text: '5',
                                              onTap: (text, icon) {
                                                controller.text += text!;
                                              }),
                                          KeyButton(
                                              onBackgroundColor:
                                                  widget.onBackgroundColor,
                                              text: '6',
                                              onTap: (text, icon) {
                                                controller.text += text!;
                                              })
                                        ])),
                                SizedBox(
                                    height: buttonHeight,
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          KeyButton(
                                              onBackgroundColor:
                                                  widget.onBackgroundColor,
                                              text: '7',
                                              onTap: (text, icon) {
                                                controller.text += text!;
                                              }),
                                          KeyButton(
                                              onBackgroundColor:
                                                  widget.onBackgroundColor,
                                              text: '8',
                                              onTap: (text, icon) {
                                                controller.text += text!;
                                              }),
                                          KeyButton(
                                              onBackgroundColor:
                                                  widget.onBackgroundColor,
                                              text: '9',
                                              onTap: (text, icon) {
                                                controller.text += text!;
                                              })
                                        ])),
                                SizedBox(
                                    height: buttonHeight,
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          KeyButton(
                                              onBackgroundColor:
                                                  widget.onBackgroundColor,
                                              icon: Icons.backspace,
                                              onLongTap: () {
                                                controller.text = '';
                                                vibrate();
                                              },
                                              onTap: (text, icon) {
                                                if (controller.text.isNotEmpty) {
                                                  controller.text =
                                                      controller.text.substring(
                                                          0,
                                                          controller.text.length -
                                                              1);
                                                  vibrate();
                                                }
                                              }),
                                          KeyButton(
                                              onBackgroundColor:
                                                  widget.onBackgroundColor,
                                              text: '0',
                                              onTap: (text, icon) {
                                                controller.text += text!;
                                              }),
                                          KeyButton(
                                              onBackgroundColor:
                                                  widget.onBackgroundColor,
                                              icon: Icons.check,
                                              onTap: (text, icon) {
                                                submit();
                                                vibrate();
                                              })
                                        ]))
                              ])))
              ])),
    );
  }
}

class KeyButton extends StatelessWidget {
  const KeyButton(
      {super.key,
      this.text,
      this.icon,
      required this.onBackgroundColor,
      required this.onTap,
      this.onLongTap});

  final String? text;
  final IconData? icon;
  final Function(String? text, IconData? icon) onTap;
  final Function()? onLongTap;
  final Color onBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)))),
            onLongPress: onLongTap,
            onPressed: () => onTap(text, icon),
            child: Center(
                child: text == null
                    ? Icon(icon, color: onBackgroundColor)
                    : Text(
                        text!,
                        style:
                            TextStyle(color: onBackgroundColor, fontSize: 24),
                      ))));
  }
}
