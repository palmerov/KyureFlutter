import 'package:flutter/material.dart';

class BottomItemActionMolecule extends StatelessWidget {
  const BottomItemActionMolecule(
      {super.key,
      required this.icon,
      required this.text,
      this.onTap,
      this.color});
  final Widget icon;
  final String text;
  final Function()? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(
              height: 4,
            ),
            Text(
              text,
              style: TextStyle(color: color, fontSize: 11),
            )
          ],
        ),
      ),
    );
  }
}
