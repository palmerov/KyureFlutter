import 'package:flutter/material.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';

class ContextMenuTileMolecule extends StatelessWidget {
  const ContextMenuTileMolecule(
      {super.key,
      this.onTap,
      required this.label,
      required this.icon,
      this.textStyle,
      this.separation,
      this.padding});

  final Function()? onTap;
  final String label;
  final Widget icon;
  final TextStyle? textStyle;
  final double? separation;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final kTheme = KyTheme.of(context)!;
    return InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: Row(children: [
            icon,
            SizedBox(
              width: separation ?? 8,
            ),
            Expanded(
                child: Text(label,
                    style: textStyle ??
                        TextStyle(color: kTheme.colorOnBackground)))
          ]),
        ));
  }
}
