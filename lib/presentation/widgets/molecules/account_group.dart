import 'package:flutter/material.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';

class AccountGroupMolecule extends StatelessWidget {
  const AccountGroupMolecule(
      {super.key,
      required this.text,
      this.icon,
      this.onTap,
      required this.selected,
      required this.color,
      this.paddingHorizontal,
      this.onLongTap,
      this.radius});
  final String text;
  final Color color;
  final Widget? icon;
  final Function()? onTap;
  final Function()? onLongTap;
  final bool selected;
  final double? paddingHorizontal;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal ?? 4),
      child: Container(
        decoration: BoxDecoration(
            color: selected
                ? color.withOpacity(0.08)
                : kyTheme.colorBackground,
            border: Border.all(
                color: selected
                    ? color.withOpacity(0.5)
                    : kyTheme.colorSeparatorLine,
                width: selected ? 1 : kyTheme.borderWidth05),
            borderRadius: BorderRadius.all(Radius.circular(radius??16))),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongTap,
          onSecondaryTap: onLongTap,
          borderRadius: BorderRadius.all(Radius.circular(radius?? 16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Center(
              child: (icon != null
                  ? Row(
                      children: [
                        icon!,
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          text,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          maxLines: 1,
                        )
                      ],
                    )
                  : Text(
                      text,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 1,
                    )),
            ),
          ),
        ),
      ),
    );
  }
}
