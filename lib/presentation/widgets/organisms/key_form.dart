import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class KeyFormController {}

class KeyFormOrganism extends StatefulWidget {
  const KeyFormOrganism(
      {super.key,
      this.title,
      this.onBackgroundColor = Colors.white,
      required this.onTapEnter,
      this.error,
      required this.obscureText});
  final String? title;
  final Color onBackgroundColor;
  final Future Function(String key) onTapEnter;
  final String? error;
  final bool obscureText;

  @override
  State<KeyFormOrganism> createState() => _KeyFormOrganismState();
}

class _KeyFormOrganismState extends State<KeyFormOrganism> {
  bool keyboard = false;
  late final TextEditingController controller;
  String? error;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    error = widget.error;
    controller = TextEditingController();
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
    error = await widget.onTapEnter(text);
    if (error == null) controller.text = '';
    if (error != null) {
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
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.title != null)
            Text(
              widget.title!,
              textAlign: TextAlign.center,
              style: TextStyle(color: widget.onBackgroundColor, fontSize: 16),
            ),
          Visibility(
            visible: error != null,
            maintainSize: false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                error ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade200, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextFormField(
              onFieldSubmitted: (value) {
                submit();
              },
              controller: controller,
              obscureText: widget.obscureText,
              autofocus: keyboard,
              readOnly: loading,
              textAlign: TextAlign.center,
              style: TextStyle(color: widget.onBackgroundColor, fontSize: 18),
              canRequestFocus: Platform.isLinux ||
                  Platform.isWindows ||
                  Platform.isMacOS ||
                  keyboard,
              cursorColor: widget.onBackgroundColor,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 48, right: 0, top: 16, bottom: 16),
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
                    : Platform.isAndroid || Platform.isMacOS
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap: () => setState(() => keyboard = !keyboard),
                              child: Icon(
                                !keyboard
                                    ? CupertinoIcons.keyboard
                                    : CupertinoIcons.number,
                                color: widget.onBackgroundColor,
                              ),
                            ),
                          )
                        : null,
                hintText: 'Llave de cifrado',
                hintStyle:
                    TextStyle(color: widget.onBackgroundColor.withOpacity(0.4)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: widget.onBackgroundColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: widget.onBackgroundColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: widget.onBackgroundColor),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Visibility(
            maintainSize: false,
            visible: !keyboard,
            child: SizedBox(
              height: 300,
              child: GridView.builder(
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 66, crossAxisCount: 3),
                itemBuilder: (context, index) {
                  if (index < 9) {
                    return SizedBox(
                      height: 20,
                      child: InkWell(
                        onTap: () {
                          controller.text += '${index + 1}';
                          vibrate();
                        },
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                                color: widget.onBackgroundColor, fontSize: 24),
                          ),
                        ),
                      ),
                    );
                  } else {
                    if (index == 9) {
                      return InkWell(
                        onLongPress: () {
                          controller.text = '';
                          vibrate();
                        },
                        onTap: () {
                          if (controller.text.isNotEmpty) {
                            controller.text = controller.text
                                .substring(0, controller.text.length - 1);
                            vibrate();
                          }
                        },
                        child: Center(
                          child: Icon(
                            CupertinoIcons.delete_left_fill,
                            color: widget.onBackgroundColor,
                          ),
                        ),
                      );
                    }
                    if (index == 10) {
                      return InkWell(
                        onTap: () {
                          controller.text += '${0}';
                          vibrate();
                        },
                        child: Center(
                          child: Text(
                            '0',
                            style: TextStyle(
                                color: widget.onBackgroundColor, fontSize: 24),
                          ),
                        ),
                      );
                    }
                    if (index == 11) {
                      return InkWell(
                        onTap: submit,
                        child: Center(
                          child: Icon(
                            CupertinoIcons.check_mark,
                            color: widget.onBackgroundColor,
                          ),
                        ),
                      );
                    }
                  }
                },
                itemCount: 12,
              ),
            ),
          )
        ],
      ),
    );
  }
}
