import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/config/router_config.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/presentation/pages/account_list/account_list_bloc.dart';
import 'package:kyure/presentation/widgets/atoms/list_item_separator.dart';
import 'package:kyure/presentation/widgets/molecules/account_group.dart';
import 'package:kyure/presentation/widgets/molecules/account_group_list_shimmer.dart';
import 'package:kyure/presentation/widgets/molecules/account_item.dart';
import 'package:kyure/presentation/widgets/molecules/account_list_shimmer.dart';
import 'package:kyure/presentation/widgets/molecules/search_bar.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/svg_icon.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:blur/blur.dart';

class AccountListPage extends StatelessWidget {
  const AccountListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AccountListPageBloc(serviceLocator.getUserDataService())..load(),
      child: _AccountListView(),
    );
  }
}

class _AccountListView extends StatelessWidget {
  _AccountListView({super.key}) {
    keyScaffold = GlobalKey<ScaffoldState>();
    pageController = PageController();
  }
  late final GlobalKey<ScaffoldState> keyScaffold;
  late final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final wsizeP = MediaQuery.of(context).size;
    final kyTheme = KyTheme.of(context)!;
    AccountListPageBloc bloc = BlocProvider.of<AccountListPageBloc>(context);
    return Scaffold(
      key: keyScaffold,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                kyTheme.light ? Brightness.dark : Brightness.light,
            statusBarColor: kyTheme.colorBackground),
      ),
      body: Stack(
        children: [
          BlocConsumer<AccountListPageBloc, AccountListPageState>(
            listener: (context, state) {},
            buildWhen: (previous, current) =>
                previous.runtimeType != current.runtimeType &&
                (previous is AccountListPageStateLoading ||
                    current is AccountListPageStateLoaded ||
                    current is AccountListPageFilteredState),
            builder: (context, state) {
              if (state is AccountListPageStateLoading ||
                  state is AccountListPageStateInitial) {
                return const AccountListShimmerMolecule();
              } else {
                return Positioned.fill(
                  child:
                      BlocListener<AccountListPageBloc, AccountListPageState>(
                    listenWhen: (previous, current) =>
                        previous != current &&
                        current is AccountListPageSelectedGroupState,
                    listener: (context, state) async {
                      if (state is AccountListPageSelectedGroupState) {
                        bloc.listenPageView = false;
                        await pageController.animateToPage(
                            state.selectedGroupIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                        bloc.listenPageView = true;
                      }
                    },
                    child: PageView.builder(
                      itemCount: state.accountGroups.length,
                      controller: pageController,
                      onPageChanged: (value) =>
                          {if (bloc.listenPageView) bloc.selectGroup(value)},
                      itemBuilder: (context, groupIndex) => Center(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(top: 100, bottom: 60),
                          itemBuilder: (context, accountIndex) {
                            Account account = state.accountGroups[groupIndex]
                                .accounts[accountIndex];
                            return AccountItemMolecule(
                              account: account,
                              onTap: () => context.pushNamed(
                                  KyRoutes.accountEditor.name,
                                  queryParameters: {'id': '${account.id}'}),
                            );
                          },
                          itemCount: state.accountGroups.isEmpty
                              ? 0
                              : state.accountGroups[groupIndex].accounts.length,
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Stack(
              children: [
                Positioned.fill(
                    child: Blur(
                        colorOpacity: kyTheme.blurOpacity,
                        blurColor: kyTheme.colorBackground,
                        child: const SizedBox.shrink())),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: BlocBuilder<AccountListPageBloc,
                          AccountListPageState>(
                        buildWhen: (previous, current) =>
                            previous != current &&
                                previous is AccountListPageStateLoading ||
                            previous is AccountListPageStateInitial,
                        builder: (context, state) {
                          return SearchBarMolecule(
                            enabled: state is! AccountListPageStateLoading,
                            onSearchChanged: (text) => bloc.filter(text),
                            onLeadingTap: () {
                              keyScaffold.currentState!.openDrawer();
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 4, right: 4, bottom: 8),
                      child: SizedBox(
                          height: 34,
                          child: BlocBuilder<AccountListPageBloc,
                              AccountListPageState>(
                            buildWhen: (previous, current) =>
                                previous != current &&
                                    current is AccountListPageFilteredState ||
                                current is AccountListPageSelectedGroupState ||
                                current is AccountListPageStateLoaded,
                            builder: (context, state) {
                              if (state is AccountListPageStateLoading ||
                                  state is AccountListPageStateInitial) {
                                return const AccountGroupListShimmerMolecule();
                              }
                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, groupIndex) {
                                  final group = state.accountGroups[groupIndex];
                                  return AccountGroupMolecule(
                                      text: group.name,
                                      color: Color(group.color),
                                      icon: SvgIcon(svgAsset: group.iconName),
                                      onTap: () => bloc.selectGroup(groupIndex),
                                      selected: state.selectedGroupIndex ==
                                          groupIndex);
                                },
                                itemCount: state.accountGroups.length,
                              );
                            },
                          )),
                    )
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: kyTheme.borderWidth03,
                    child:
                        ColoredBox(color: kyTheme.colorOnBackgroundOpacity30),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              height: 60,
              child: SizedBox(
                height: 60,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Blur(
                        colorOpacity: kyTheme.blurOpacity,
                        blurColor: kyTheme.colorBackground,
                        child: const SizedBox.shrink(),
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ItemAction(
                              icon: Icon(CupertinoIcons.lock,
                                  color: kyTheme.colorOnBackgroundOpacity60),
                              text: 'Bloquear',
                              onTap: () {},
                            ),
                            ItemAction(
                              icon: Icon(CupertinoIcons.list_number,
                                  color: kyTheme.colorOnBackgroundOpacity60),
                              text: 'Orden',
                              onTap: () {},
                            ),
                            ItemAction(
                              icon: Icon(
                                  CupertinoIcons.rectangle_on_rectangle_angled,
                                  color: kyTheme.colorOnBackgroundOpacity60),
                              text: '+ Grupo',
                              onTap: () {},
                            ),
                            ItemAction(
                              icon: Icon(CupertinoIcons.person,
                                  color: kyTheme.colorOnBackgroundOpacity60),
                              text: '+ Cuenta',
                              onTap: () {
                                context.push(KyRoutes.accountEditor.routePath);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: kyTheme.borderWidth03,
                        child: ColoredBox(
                            color: kyTheme.colorOnBackgroundOpacity30),
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
      drawer: const NavigationDrawer(children: []),
    );
  }
}

class ItemAction extends StatelessWidget {
  const ItemAction(
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
              height: 2,
            ),
            Text(
              text,
              style: TextStyle(color: color),
            )
          ],
        ),
      ),
    );
  }
}
