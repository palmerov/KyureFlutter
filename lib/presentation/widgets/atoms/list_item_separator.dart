import 'package:flutter/material.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';

class ListItemSeparatorAtom extends StatelessWidget {
  const ListItemSeparatorAtom({super.key, this.margin});

  final EdgeInsets? margin;
  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    return Padding(
      padding: margin ?? const EdgeInsets.only(left: 66, right: 8),
      child: SizedBox(
          height: kyTheme.listItemSeparatorHeight,
          child: ColoredBox(color: kyTheme.colorSeparatorLine)),
    );
  }
}
