import 'package:flutter/material.dart';
import 'package:kyure/main.dart';

class PageBodyConstraintAtom extends StatelessWidget {
  final Widget child;

  const PageBodyConstraintAtom({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isPC ? 500 : double.maxFinite),
        child: child);
  }
}
