import 'package:flutter/material.dart';

class ContextMenuTileMolecule extends StatelessWidget {
  const ContextMenuTileMolecule(
      {super.key, this.onTap, required this.label, required this.icon});

  final Function()? onTap;
  final String label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(children: [
            icon,
            const SizedBox(
              width: 8,
            ),
            Expanded(child: Text(label))
          ]),
        ));
  }
}
