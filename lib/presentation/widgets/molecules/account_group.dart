import 'package:flutter/material.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';

class AccountGroupMolecule extends StatelessWidget {
  const AccountGroupMolecule(
      {super.key,
      required this.text,
      this.icon,
      required this.onTap,
      required this.selected});
  final String text;
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
            color: selected ? kyTheme.colorSeparatorLine : null,
            border: Border.all(color: kyTheme.colorSeparatorLine, width: 1),
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
