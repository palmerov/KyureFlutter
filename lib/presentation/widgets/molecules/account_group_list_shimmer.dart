//shimmer for account list
import 'package:flutter/material.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/account_group.dart';
import 'package:shimmer/shimmer.dart';

class AccountGroupListShimmerMolecule extends StatelessWidget {
  const AccountGroupListShimmerMolecule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: kyTheme.colorSeparatorLine,
          highlightColor: kyTheme.colorBackground,
          child: AccountGroupMolecule(
            text: 'Loading',
            icon: const Icon(Icons.square),
            onTap: () {},
            selected: index == 0,
          ),
        );
      }
      
    );
  }
}
