import 'package:flutter/material.dart';

class ToastWidgetMolecule extends StatelessWidget {
  const ToastWidgetMolecule(
      {super.key,
      required this.text,
      required this.textStyle,
      required this.backgroundColor,
      this.prefix});
  final String text;
  final TextStyle textStyle;
  final Color backgroundColor;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      elevation: 4,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: prefix == null
            ? Text(
                text,
                style: textStyle,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  prefix!,
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    text,
                    style: textStyle,
                  )
                ],
              ),
      ),
    );
  }
}
