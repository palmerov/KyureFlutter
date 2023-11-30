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
      this.paddingHorizontal});
  final String text;
  final Color color;
  final Widget? icon;
  final Function()? onTap;
  final bool selected;
  final double? paddingHorizontal;

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal ?? 4),
      child: Container(
        decoration: BoxDecoration(
            color: selected
                ? kyTheme.colorBackground.withOpacity(0.8)
                : kyTheme.colorBackground,
            border: Border.all(
                color: selected
                    ? color.withOpacity(0.5)
                    : kyTheme.colorOnBackgroundOpacity30,
                width: selected ? 1 : kyTheme.borderWidth05),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
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
