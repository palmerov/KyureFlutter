import 'package:flutter/material.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';

class ListItemSeparatorAtom extends StatelessWidget {
  const ListItemSeparatorAtom({super.key, this.margin});

  final EdgeInsets? margin;
  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    return Padding(
      padding: margin ?? const EdgeInsets.only(left: 16, right: 16),
      child: SizedBox(
          height: kyTheme.borderWidth,
          child: ColoredBox(color: kyTheme.colorOnBackgroundOpacity30)),
    );
  }
}
