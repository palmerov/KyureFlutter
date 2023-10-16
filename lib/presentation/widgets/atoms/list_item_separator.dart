import 'package:flutter/material.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';

class ListItemSeparatorAtom extends StatelessWidget {
  const ListItemSeparatorAtom({super.key, this.marginHorizontal, this.marginVertical});

  final double? marginHorizontal;
  final double? marginVertical;

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: marginHorizontal??8, vertical: marginVertical??0),
      child: SizedBox(
          height: kyTheme.listItemSeparatorHeight,
          child: ColoredBox(color: kyTheme.colorSeparatorLine)),
    );
  }
}
