import 'package:flutter/material.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';

class AccountGroupMolecule extends StatelessWidget {
  const AccountGroupMolecule(
      {super.key,
      required this.text,
      this.icon,
      required this.onTap,
      required this.selected,
      required this.color});
  final String text;
  final Color color;
  final Widget? icon;
  final Function() onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
            color: selected
                ? kyTheme.colorBackground.withOpacity(0.4)
                : kyTheme.colorBackground,
            border: Border.all(
                color: selected ? color : kyTheme.colorOnBackgroundOpacity50,
                width: selected ? 1 : kyTheme.borderWidth),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
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
                        Text(text)
                      ],
                    )
                  : Text(text)),
            ),
          ),
        ),
      ),
    );
  }
}
