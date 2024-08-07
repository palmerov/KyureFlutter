import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/config/router_config.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/data/utils/dialog_utils.dart';
import 'package:kyure/main.dart';
import 'package:kyure/presentation/pages/account_list/account_list_bloc.dart';
import 'package:kyure/presentation/pages/account_list/extensions/account_list_bloc_listener_extension.dart';
import 'package:kyure/presentation/pages/account_list/extensions/account_list_dialog_extension.dart';
import 'package:kyure/presentation/pages/account_list/views/drawer.dart';
import 'package:kyure/presentation/widgets/atoms/any_image.dart';
import 'package:kyure/presentation/widgets/molecules/account_group.dart';
import 'package:kyure/presentation/widgets/molecules/account_group_list_shimmer.dart';
import 'package:kyure/presentation/widgets/molecules/account_item.dart';
import 'package:kyure/presentation/widgets/molecules/account_list_shimmer.dart';
import 'package:kyure/presentation/widgets/molecules/blured_bottom_app_bar/export.dart';
import 'package:kyure/presentation/widgets/molecules/context_menu_tile.dart';
import 'package:kyure/presentation/widgets/molecules/image_rounded.dart';
import 'package:kyure/presentation/widgets/molecules/search_bar.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/presentation/widgets/molecules/svg_icon.dart';
import 'package:blur/blur.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:kyure/services/vault_service.dart';
import 'package:kyure/utils/extensions.dart';
import 'package:kyure/utils/extensions_classes.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../data/models/sync_result.dart';
import '../../widgets/molecules/toast_widget.dart';

class AccountListPage extends StatelessWidget {
  const AccountListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountListPageBloc()..load(),
      child: AccountListView(),
    );
  }
}

class AccountListView extends StatelessWidget {
  AccountListView({super.key}) {
    _keyScaffold = GlobalKey<ScaffoldState>();
    _pageController = PageController();
  }

  late final GlobalKey<ScaffoldState> _keyScaffold;
  late final PageController _pageController;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final FocusNode _searchBarFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    AccountListPageBloc bloc = BlocProvider.of<AccountListPageBloc>(context);
    final bool isPcScreen = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      key: _keyScaffold,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                kyTheme.light ? Brightness.dark : Brightness.light,
            statusBarColor: kyTheme.colorBackground),
      ),
      body: SafeArea(
          child: Row(children: [
        if (isPcScreen) KiureDrawer(isPcScreen: isPcScreen),
        Expanded(
            child: Stack(children: [
          BlocConsumer<AccountListPageBloc, AccountListPageState>(
              listener: (context, state) => listenToBloc(context, bloc, state),
              buildWhen: (previous, current) =>
                  previous.runtimeType != current.runtimeType &&
                      (previous is AccountListPageStateLoading ||
                          current is AccountListPageStateLoaded ||
                          current is AccountListPageFilteredState ||
                          current is AccountListSyncResult) ||
                  previous.version != current.version ||
                  previous != current,
              builder: (context, state) {
                if (state is AccountListPageStateLoading ||
                    state is AccountListPageStateInitial) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: AccountListShimmerMolecule(),
                  );
                } else {
                  return Positioned.fill(
                      child: BlocListener<AccountListPageBloc,
                              AccountListPageState>(
                          listenWhen: (previous, current) =>
                              previous != current &&
                              current is AccountListPageSelectedGroupState,
                          listener: (context, state) async {
                            if (state is AccountListPageSelectedGroupState) {
                              bloc.listenPageView = false;
                              await _pageController.animateToPage(
                                  state.selectedGroupIndex,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                              bloc.listenPageView = true;
                            }
                          },
                          child: PageView.builder(
                              itemCount: state.groups.length,
                              controller: _pageController,
                              physics: const BouncingScrollPhysics(),
                              onPageChanged: (value) {
                                if (bloc.listenPageView) {
                                  _itemScrollController.scrollTo(
                                      index: value,
                                      duration:
                                          const Duration(milliseconds: 200));
                                  bloc.selectGroup(value);
                                }
                              },
                              itemBuilder: (context, groupIndex) => Center(
                                  child: BlocBuilder<AccountListPageBloc,
                                          AccountListPageState>(
                                      buildWhen: (previous, current) =>
                                          previous.version != current.version ||
                                          current
                                              is AccountListPageFilteredState,
                                      builder: (context, state) {
                                        List<Account> pageAccounts =
                                            bloc.getAccountsFromGroupIndex(
                                                groupIndex);
                                        return RefreshIndicator(
                                            onRefresh: () async {
                                              syncVault(context);
                                            },
                                            edgeOffset: 120,
                                            strokeWidth: 2,
                                            triggerMode:
                                                RefreshIndicatorTriggerMode
                                                    .onEdge,
                                            child: ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              padding: const EdgeInsets.only(
                                                  top: 100, bottom: 60),
                                              itemBuilder:
                                                  (context, accountIndex) {
                                                Account account =
                                                    pageAccounts[accountIndex];
                                                return AccountItemMolecule(
                                                  account: account,
                                                  onTap: () =>
                                                      openAccountDetails(
                                                          bloc,
                                                          context,
                                                          account,
                                                          false),
                                                  onLongTap: () =>
                                                      showAccountContextMenuDialog(
                                                          bloc,
                                                          context,
                                                          account),
                                                );
                                              },
                                              itemCount: pageAccounts.length,
                                            ));
                                      })))));
                }
              }),
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Stack(children: [
                Positioned.fill(
                    child: Blur(
                        colorOpacity: kyTheme.blurOpacity,
                        blurColor: kyTheme.colorBackground,
                        child: const SizedBox.shrink())),
                Column(children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child:
                        BlocBuilder<AccountListPageBloc, AccountListPageState>(
                      buildWhen: (previous, current) =>
                          previous != current &&
                              previous is AccountListPageStateLoading ||
                          previous is AccountListPageStateInitial,
                      builder: (context, state) {
                        return SearchBarMolecule(
                          hintText: 'Buscar',
                          focusNode: _searchBarFocusNode,
                          enabled: state is! AccountListPageStateLoading,
                          onSearchChanged: (text) => bloc.filter(text),
                          onLeadingTap: () {
                            _keyScaffold.currentState!.openDrawer();
                          },
                          showLeading: !isPcScreen,
                        );
                      },
                    ),
                  ),
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 4, right: 4, bottom: 8),
                      child: SizedBox(
                          height: 36,
                          child: BlocBuilder<AccountListPageBloc,
                                  AccountListPageState>(
                              buildWhen: (previous, current) =>
                                  (previous != current &&
                                      (current
                                              is AccountListPageFilteredState ||
                                          current
                                              is AccountListPageSelectedGroupState ||
                                          current
                                              is AccountListPageStateLoaded ||
                                          current
                                              is AccountListPageStateLoading)) ||
                                  previous.version != current.version,
                              builder: (context, state) {
                                if (state is AccountListPageStateLoading ||
                                    state is AccountListPageStateInitial) {
                                  return const AccountGroupListShimmerMolecule();
                                }
                                return ScrollablePositionedList.builder(
                                  itemScrollController: _itemScrollController,
                                  physics: const ClampingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, groupIndex) {
                                    final group = state.groups[groupIndex];
                                    return AccountGroupMolecule(
                                        text: group.name,
                                        color: Color(group.color),
                                        icon: SvgIcon(svgAsset: group.iconName),
                                        onTap: () =>
                                            bloc.selectGroup(groupIndex),
                                        onLongTap: groupIndex != 0
                                            ? () => showGroupContextMenuDialog(
                                                bloc, context, group)
                                            : null,
                                        selected: state.selectedGroupIndex ==
                                            groupIndex);
                                  },
                                  itemCount: state.groups.length,
                                );
                              })))
                ])
              ])),
          BlocBuilder<AccountListPageBloc, AccountListPageState>(
            builder: (context, state) {
              if(state is AccountListPageStateLoading){
                return const SizedBox.shrink();
              }
              return Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  height: 60,
                  child: BluredBottomAppBarMolecule(items: [
                    BottomItemActionMolecule(
                        icon: Icon(CupertinoIcons.list_number,
                            color: kyTheme.colorOnBackgroundOpacity60),
                        text: 'Orden',
                        onTap: () => showSortDialog(context)),
                    BottomItemActionMolecule(
                        icon: Icon(CupertinoIcons.arrow_2_circlepath,
                            color: kyTheme.colorOnBackgroundOpacity60),
                        text: 'Sincronizar',
                        onTap: () => syncVault(context)),
                    BottomItemActionMolecule(
                        icon: Icon(CupertinoIcons.search,
                            color: kyTheme.colorOnBackgroundOpacity60),
                        text: 'Buscar',
                        onTap: () => _searchBarFocusNode.requestFocus()),
                    BottomItemActionMolecule(
                        icon: Icon(CupertinoIcons.rectangle_on_rectangle_angled,
                            color: kyTheme.colorOnBackgroundOpacity60),
                        text: '+ Grupo',
                        onTap: () async {
                          final saved = await context
                              .pushNamed(KyRoutes.groupEditor.name);
                          if (saved != null && (saved as bool)) {
                            bloc.reload(true);
                          }
                        }),
                    BottomItemActionMolecule(
                        icon: Icon(CupertinoIcons.person,
                            color: kyTheme.colorOnBackgroundOpacity60),
                        text: '+ Cuenta',
                        onTap: () async {
                          final result = await context.pushNamed(
                              KyRoutes.accountEditor.name,
                              queryParameters: {
                                'groupId': '${bloc.getSelectedGroup().id}'
                              });
                          if (result != null && (result as bool)) {
                            bloc.reload(true);
                          }
                        })
                  ]));
            },
          )
        ]))
      ])),
      drawer: isPcScreen ? null : KiureDrawer(isPcScreen: isPcScreen),
    );
  }

  openAccountDetails(AccountListPageBloc bloc, BuildContext context,
      Account account, bool editting) async {
    final updated = await context.pushNamed(KyRoutes.accountEditor.name,
        queryParameters: {'id': '${account.id}', 'editting': '$editting'});
    if (updated != null) {
      bloc.reload(true);
    }
  }

  void syncVault(BuildContext context,
      [KeyConflictResolver? keyConflictResolver]) async {
    if (serviceLocator.getKiureService().remoteSettings != null) {
      context.read<AccountListPageBloc>().syncVault(keyConflictResolver);
    } else {
      context.pushNamed(KyRoutes.cloudSettings.name);
    }
  }
}
