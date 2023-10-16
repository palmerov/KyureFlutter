import 'package:flutter/material.dart';
import 'package:kyure/presentation/widgets/atoms/list_item_separator.dart';
import 'package:kyure/presentation/widgets/molecules/account_item.dart';

class AccountListOrganism extends StatelessWidget {
  const AccountListOrganism({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        switch (index % 4) {
          case 0:
            return const AccountItemMolecule(
              imageAsset: 'assets/icons/bingx.png',
              name: 'BingX',
              username: 'palmerovaldes99@gmail.com',
              password: '9wedshjias',
            );
          case 1:
            return const AccountItemMolecule(
              imageAsset: 'assets/icons/google.png',
              name: 'Google',
              username: 'palmerovaldes99@gmail.com',
              password: '9wedshjias',
            );
          case 2:
            return const AccountItemMolecule(
              imageAsset: 'assets/icons/tropipay.jpg',
              name: 'TropiPay',
              username: 'palmerovaldes99@gmail.com',
              password: '9wedshjias',
            );
          case 3:
            return const AccountItemMolecule(
              imageAsset: 'assets/icons/twiter.png',
              name: 'Twiter',
              username: 'palmero_valdes',
              password: '9wedshjias',
            );
        }
      },
      itemCount: 30,
      separatorBuilder: (BuildContext context, int index) =>
          const ListItemSeparatorAtom(),
    );
  }
}
