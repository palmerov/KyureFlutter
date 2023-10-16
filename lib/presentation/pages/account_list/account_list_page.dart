import 'package:flutter/material.dart';
import 'package:kyure/presentation/widgets/atoms/list_item_separator.dart';
import 'package:kyure/presentation/widgets/molecules/account_group.dart';
import 'package:kyure/presentation/widgets/molecules/account_item.dart';
import 'package:kyure/presentation/widgets/molecules/search_bar.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';

class AccountListPage extends StatelessWidget {
  const AccountListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _AccountListView();
  }
}

class _AccountListView extends StatelessWidget {
  _AccountListView({super.key});

  final GlobalKey<ScaffoldState> keyScaffold = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final wsize = MediaQuery.of(context).size;
    final kyTheme = KyTheme.of(context)!;
    return Scaffold(
      key: keyScaffold,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              backgroundColor: kyTheme.colorBackground,
              centerTitle: false,
              leadingWidth: 0,
              titleSpacing: 8,
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SearchBarMolecule(
                  onSearchChanged: (text) {},
                  onLeadingTap: () {
                    keyScaffold.currentState!.openDrawer();
                  },
                ),
              ),
              floating: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: SizedBox(
                      height: 32,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          AccountGroupMolecule(
                            selected: true,
                            text: 'Todas',
                            icon: Icon(
                              Icons.widgets,
                              color: kyTheme.colorHint,
                              size: 16,
                            ),
                            onTap: () {},
                          ),
                          AccountGroupMolecule(
                            selected: false,
                            icon: Icon(
                              Icons.wallet,
                              color: kyTheme.colorHint,
                              size: 16,
                            ),
                            text: 'Dinero',
                            onTap: () {},
                          ),
                          AccountGroupMolecule(
                            selected: false,
                            icon: Icon(
                              Icons.work,
                              color: kyTheme.colorHint,
                              size: 16,
                            ),
                            text: 'Trabajo',
                            onTap: () {},
                          ),
                          AccountGroupMolecule(
                            selected: false,
                            icon: Icon(
                              Icons.person,
                              color: kyTheme.colorHint,
                              size: 16,
                            ),
                            text: 'Personales',
                            onTap: () {},
                          ),
                        ],
                      )),
                ),
              )),
          SliverList.separated(
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
          )
        ],
      ),
      drawer: NavigationDrawer(children: []),
    );
  }
}
