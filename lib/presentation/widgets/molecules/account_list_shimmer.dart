//shimmer for account list
import 'package:flutter/material.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/atoms/list_item_separator.dart';
import 'package:kyure/presentation/widgets/molecules/account_item.dart';
import 'package:shimmer/shimmer.dart';

class AccountListShimmerMolecule extends StatelessWidget {
  const AccountListShimmerMolecule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: kyTheme.colorSeparatorLine,
          highlightColor: kyTheme.colorBackground,
          child: const AccountItemMolecule(
            imageAsset: 'assets/web_icons/squared.png',
              name: 'Loading', username: 'loading', password: ''),
        );
      },
      separatorBuilder: (context, index) {
        return Shimmer.fromColors(
            baseColor: kyTheme.colorSeparatorLine,
            highlightColor: kyTheme.colorBackground,
            child: const ListItemSeparatorAtom());
      },
    );
  }
}
