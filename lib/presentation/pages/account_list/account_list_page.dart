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
import 'package:kyure/utils/extensions.dart';
import 'package:kyure/utils/extensions_classes.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AccountListPage extends StatelessWidget {
  const AccountListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountListPageBloc()..load(),
      child: _AccountListView(),
    );
  }
}

class _AccountListView extends StatelessWidget {
  _AccountListView({super.key}) {
    _keyScaffold = GlobalKey<ScaffoldState>();
    _pageController = PageController();
  }

  late final GlobalKey<ScaffoldState> _keyScaffold;
  late final PageController _pageController;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final FocusNode _searchBarFocusNode = FocusNode();

  _showAccountContextMenuDialog(
      AccountListPageBloc bloc, BuildContext context, Account account) {
    context.showOptionListDialog(
        account.name,
        ImageRounded(
            radius: 8,
            image: AnyImage(
                source: AnyImageSource.fromJson(account.image.source.toJson()),
                image: account.image.path),
            size: 24),
        [
          Option('Editar', const Icon(Icons.edit), () {
            context.pop();
            _openAccountDetails(bloc, context, account, true);
          }),
          Option('Eliminar', const Icon(CupertinoIcons.delete), () {
            context.pop();
            context.showYesOrNoDialog('Eliminar cuenta',
                'Estás a punto de eliminar la cuenta "${account.name}".', () {
              bloc.deleteAccount(account);
              return true;
            }, () => true, 'Eliminar', 'Conservar');
          }),
        ]);
  }

  _showGroupContextMenuDialog(
      AccountListPageBloc bloc, BuildContext context, AccountGroup group) {
    context
        .showOptionListDialog(group.name, SvgIcon(svgAsset: group.iconName), [
      Option('Editar', const Icon(Icons.edit_outlined), () async {
        context.pop();
        final edited = await context.pushNamed(KyRoutes.groupEditor.name,
            queryParameters: {'id': '${group.id}'});
        if (edited != null && (edited as bool)) {
          bloc.reload(true);
        }
      }),
      Option('Eliminar', const Icon(CupertinoIcons.delete), () {
        context.pop();
        context.showYesOrNoDialog('Eliminar grupo',
            'Si eliminas el grupo, se perderán todas las cuentas vinculadas. ¿Deseas eliminarlo?',
            () {
          bloc.deleteGroup(group);
          return true;
        });
      }),
    ]);
  }

  _openAccountDetails(AccountListPageBloc bloc, BuildContext context,
      Account account, bool editting) async {
    final updated = await context.pushNamed(KyRoutes.accountEditor.name,
        queryParameters: {'id': '${account.id}', 'editting': '$editting'});
    if (updated != null) {
      bloc.reload(true);
    }
  }

  void _showSortDialog(BuildContext context) {
    final bloc = BlocProvider.of<AccountListPageBloc>(context);
    context.showOptionListDialog('Ordenamiento', const SizedBox.shrink(), [
      Option('Nombre: A -> Z', const Icon(Icons.sort_by_alpha_rounded), () {
        bloc.sort(SortBy.nameDesc);
        context.pop();
      }),
      Option('Nombre: Z -> A', const Icon(Icons.sort_by_alpha_rounded), () {
        bloc.sort(SortBy.nameAsc);
        context.pop();
      }),
      Option('Creación: reciente -> anterior', const Icon(Icons.sort_rounded),
          () {
        bloc.sort(SortBy.modifDateDesc);
        context.pop();
      }),
      Option('Creación: anterior -> reciente', const Icon(Icons.sort_rounded),
          () {
        bloc.sort(SortBy.modifDateAsc);
        context.pop();
      }),
    ]);
  }

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
        child: Row(
          children: [
            if (isPcScreen) KiureDrawer(isPcScreen: isPcScreen),
            Expanded(
              child: Stack(
                children: [
                  BlocConsumer<AccountListPageBloc, AccountListPageState>(
                    listener: (context, state) {
                      if (state.alertMessage != null) {
                        context.showQuickAlertDialog(state.alertMessage!);
                      }
                    },
                    buildWhen: (previous, current) =>
                        previous.runtimeType != current.runtimeType &&
                            (previous is AccountListPageStateLoading ||
                                current is AccountListPageStateLoaded ||
                                current is AccountListPageFilteredState) ||
                        previous.version != current.version ||
                        previous != current,
                    builder: (context, state) {
                      if (state is AccountListPageStateLoading ||
                          state is AccountListPageStateInitial) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 100, bottom: 60),
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
                                      current is AccountListPageFilteredState,
                                  builder: (context, state) {
                                    List<Account> pageAccounts = bloc
                                        .getAccountsFromGroupIndex(groupIndex);
                                    return RefreshIndicator(
                                      onRefresh: () async {
                                        bloc.syncVault();
                                      },
                                      edgeOffset: 120,
                                      strokeWidth: 2,
                                      triggerMode:
                                          RefreshIndicatorTriggerMode.onEdge,
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        padding: const EdgeInsets.only(
                                            top: 100, bottom: 60),
                                        itemBuilder: (context, accountIndex) {
                                          Account account =
                                              pageAccounts[accountIndex];
                                          return AccountItemMolecule(
                                            account: account,
                                            onTap: () => _openAccountDetails(
                                                bloc, context, account, false),
                                            onLongTap: () =>
                                                _showAccountContextMenuDialog(
                                                    bloc, context, account),
                                          );
                                        },
                                        itemCount: pageAccounts.length,
                                      ),
                                    );
                                  },
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
                                        previous
                                            is AccountListPageStateLoading ||
                                    previous is AccountListPageStateInitial,
                                builder: (context, state) {
                                  return SearchBarMolecule(
                                    focusNode: _searchBarFocusNode,
                                    enabled:
                                        state is! AccountListPageStateLoading,
                                    onSearchChanged: (text) =>
                                        bloc.filter(text),
                                    onLeadingTap: () {
                                      _keyScaffold.currentState!.openDrawer();
                                    },
                                    showLeading: !isPcScreen,
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 4, bottom: 8),
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
                                      if (state
                                              is AccountListPageStateLoading ||
                                          state
                                              is AccountListPageStateInitial) {
                                        return const AccountGroupListShimmerMolecule();
                                      }
                                      return ScrollablePositionedList.builder(
                                        itemScrollController:
                                            _itemScrollController,
                                        physics: const ClampingScrollPhysics(
                                            parent:
                                                AlwaysScrollableScrollPhysics()),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, groupIndex) {
                                          final group =
                                              state.groups[groupIndex];
                                          return AccountGroupMolecule(
                                              text: group.name,
                                              color: Color(group.color),
                                              icon: SvgIcon(
                                                  svgAsset: group.iconName),
                                              onTap: () =>
                                                  bloc.selectGroup(groupIndex),
                                              onLongTap: groupIndex != 0
                                                  ? () =>
                                                      _showGroupContextMenuDialog(
                                                          bloc, context, group)
                                                  : null,
                                              selected:
                                                  state.selectedGroupIndex ==
                                                      groupIndex);
                                        },
                                        itemCount: state.groups.length,
                                      );
                                    },
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      height: 60,
                      child: BluredBottomAppBarMolecule(
                        items: [
                          BottomItemActionMolecule(
                            icon: Icon(CupertinoIcons.list_number,
                                color: kyTheme.colorOnBackgroundOpacity60),
                            text: 'Orden',
                            onTap: () {
                              _showSortDialog(context);
                            },
                          ),
                          BottomItemActionMolecule(
                            icon: Icon(CupertinoIcons.arrow_2_circlepath,
                                color: kyTheme.colorOnBackgroundOpacity60),
                            text: 'Sincronizar',
                            onTap: () {
                              if (serviceLocator
                                      .getKiureService()
                                      .remoteSettings !=
                                  null) {
                                bloc.syncVault();
                              } else {
                                context.pushNamed(KyRoutes.cloudSettings.name);
                              }
                            },
                          ),
                          BottomItemActionMolecule(
                            icon: Icon(CupertinoIcons.search,
                                color: kyTheme.colorOnBackgroundOpacity60),
                            text: 'Buscar',
                            onTap: () => _searchBarFocusNode.requestFocus(),
                          ),
                          BottomItemActionMolecule(
                            icon: Icon(
                                CupertinoIcons.rectangle_on_rectangle_angled,
                                color: kyTheme.colorOnBackgroundOpacity60),
                            text: '+ Grupo',
                            onTap: () async {
                              final saved = await context
                                  .pushNamed(KyRoutes.groupEditor.name);
                              if (saved != null && (saved as bool)) {
                                bloc.reload(true);
                              }
                            },
                          ),
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
                            },
                          )
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: isPcScreen ? null : KiureDrawer(isPcScreen: isPcScreen),
    );
  }
}

Future<void> shareFile(String filePath, String title, String shareText) async {
  await FlutterShare.shareFile(
    title: title,
    text: shareText,
    filePath: filePath,
  );
}
