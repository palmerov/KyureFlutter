import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/config/router_config.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/main.dart';
import 'package:kyure/presentation/pages/account_list/account_list_bloc.dart';
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
import 'package:kyure/services/service_locator.dart';
import 'package:blur/blur.dart';
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

  _showAccountContextMenuDialog(
      AccountListPageBloc bloc, BuildContext context, Account account) {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ImageRounded(
                      radius: 8,
                      image: AnyImage(
                          source: AnyImageSource.fromJson(
                              account.image.source.toJson()),
                          image: account.image.path),
                      size: 24),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    account.name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              ContextMenuTileMolecule(
                  onTap: () {
                    context.pop();
                    _openAccountDetails(bloc, context, account, true);
                  },
                  label: 'Editar',
                  icon: const Icon(Icons.edit)),
              ContextMenuTileMolecule(
                  onTap: () {
                    bloc.deleteAccount(account);
                    context.pop();
                  },
                  label: 'Eliminar',
                  icon: const Icon(CupertinoIcons.delete)),
            ],
          )),
    );
  }

  _showGroupContextMenuDialog(
      AccountListPageBloc bloc, BuildContext context, AccountGroup group) {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SvgIcon(svgAsset: group.iconName),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    group.name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              ContextMenuTileMolecule(
                  onTap: () async {
                    context.pop();
                    final edited = await context
                        .pushNamed(KyRoutes.groupEditor.name, queryParameters: {
                      'name': group.name,
                      'editting': 'true'
                    });
                    if (edited != null && (edited as bool)) {
                      bloc.reload(true);
                    }
                  },
                  label: 'Editar',
                  icon: const Icon(Icons.edit)),
              ContextMenuTileMolecule(
                  onTap: () {
                    context.pop();
                    _showYesOrNoDialog(
                        context,
                        'Eliminar grupo',
                        'Si eliminas el grupo, se perderán todas las cuentas vinculadas. ¿Deseas eliminarlo?',
                        () => bloc.deleteGroup(group),
                        () => context.pop());
                  },
                  label: 'Eliminar',
                  icon: const Icon(CupertinoIcons.delete)),
            ],
          )),
    );
  }

  _showYesOrNoDialog(BuildContext buildContext, String title, String message,
      Function() onYes, Function() onNo) {
    showDialog(
      context: buildContext,
      useSafeArea: true,
      builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        context.pop();
                        onNo();
                      },
                      child: const Text('No')),
                  TextButton(
                      onPressed: () {
                        context.pop();
                        onYes();
                      },
                      child: const Text('Si')),
                ],
              )
            ],
          )),
    );
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
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ContextMenuTileMolecule(
                    onTap: () {
                      bloc.sort(SortBy.nameDesc);
                      context.pop();
                    },
                    label: 'Nombre: A -> Z',
                    icon: const Icon(Icons.sort_by_alpha_rounded)),
                ContextMenuTileMolecule(
                    onTap: () {
                      bloc.sort(SortBy.nameAsc);
                      context.pop();
                    },
                    label: 'Nombre: Z -> A',
                    icon: const Icon(Icons.sort_by_alpha_rounded)),
                ContextMenuTileMolecule(
                    onTap: () {
                      bloc.sort(SortBy.modifDateDesc);
                      context.pop();
                    },
                    label: 'Creación: reciente -> anterior',
                    icon: const Icon(Icons.sort_rounded)),
                ContextMenuTileMolecule(
                    onTap: () {
                      bloc.sort(SortBy.modifDateAsc);
                      context.pop();
                    },
                    label: 'Creación: anterior -> reciente',
                    icon: const Icon(Icons.sort_rounded)),
              ],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          );
        });
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
            if (isPcScreen) Drawer(isPcScreen: isPcScreen),
            Expanded(
              child: Stack(
                children: [
                  BlocConsumer<AccountListPageBloc, AccountListPageState>(
                    listener: (context, state) {},
                    buildWhen: (previous, current) =>
                        previous.runtimeType != current.runtimeType &&
                            (previous is AccountListPageStateLoading ||
                                current is AccountListPageStateLoaded ||
                                current is AccountListPageFilteredState) ||
                        previous.version != current.version,
                    builder: (context, state) {
                      if (state is AccountListPageStateLoading ||
                          state is AccountListPageStateInitial) {
                        return const AccountListShimmerMolecule();
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
                                    AccountGroup pageGroup =
                                        state.groups[state.selectedGroupIndex];
                                    List<Account> pageAccounts = state
                                                .selectedGroupIndex ==
                                            0
                                        ? state.accounts
                                        : state.accounts
                                            .where((element) =>
                                                element.groupId == pageGroup.id)
                                            .toList();
                                    return ListView.builder(
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
                                                current
                                                    is AccountListPageFilteredState ||
                                            current
                                                is AccountListPageSelectedGroupState ||
                                            current
                                                is AccountListPageStateLoaded) ||
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
                            icon: Icon(CupertinoIcons.arrow_2_circlepath,
                                color: kyTheme.colorOnBackgroundOpacity60),
                            text: 'Sincronizar',
                            onTap: () {
                              appBloc.lock();
                            },
                          ),
                          BottomItemActionMolecule(
                            icon: Icon(CupertinoIcons.list_number,
                                color: kyTheme.colorOnBackgroundOpacity60),
                            text: 'Orden',
                            onTap: () {
                              _showSortDialog(context);
                            },
                          ),
                          BottomItemActionMolecule(
                            icon: Icon(CupertinoIcons.lock,
                                color: kyTheme.colorOnBackgroundOpacity60),
                            text: 'Bloquear',
                            onTap: () {
                              appBloc.lock();
                            },
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
                              if (serviceLocator
                                      .getVaultService()
                                      .groups!
                                      .length ==
                                  1) {
                                _showYesOrNoDialog(context, 'No hay grupos',
                                    'Para crear una cuenta, debes tener al menos un grupo además de "Todos". ¿Continuar y crear uno?',
                                    () async {
                                  final saved = await context
                                      .pushNamed(KyRoutes.groupEditor.name);
                                  if (saved != null && (saved as bool)) {
                                    bloc.reload(true);
                                  }
                                }, () => null);
                              } else {
                                final result = await context
                                    .pushNamed(KyRoutes.accountEditor.name);
                                if (result != null && (result as bool)) {
                                  bloc.reload(true);
                                }
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
      drawer: isPcScreen ? null : Drawer(isPcScreen: isPcScreen),
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

class Drawer extends StatelessWidget {
  const Drawer({
    super.key,
    required this.isPcScreen,
    this.width,
  });
  final bool isPcScreen;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    final appBloc = context.read<ApplicationBloc>();
    return NavigationDrawer(
      elevation: isPcScreen ? 2 : 8,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 24, top: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => appBloc.toogleTheme(),
                child: Icon(appBloc.state.light
                    ? CupertinoIcons.sun_max
                    : CupertinoIcons.moon),
              )
            ],
          ),
        ),
        SizedBox(
          height: 116,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  appBloc.state.light
                      ? 'assets/app_icons/kiure_icon_name_light.png'
                      : 'assets/app_icons/kiure_icon_name_dark.png',
                  width: 100,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text('Asegura tus cuentas'),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        _buildDrawerItem(
            kyTheme: kyTheme,
            onTap: () => context.pushNamed(KyRoutes.keyEditor.name),
            label: 'Cambiar clave',
            icon: const Icon(CupertinoIcons.lock)),
        _buildDrawerItem(
            kyTheme: kyTheme,
            label: 'Exportar bóveda',
            icon: const Icon(CupertinoIcons.share),
            onTap: () async {
              String path =
                  await context.read<AccountListPageBloc>().exportFile();
              // ignore: use_build_context_synchronously
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  content:
                      Text('Tu archivo de cuentas ha sido exportado a: $path'),
                  actions: [
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('Copiar directorio'),
                      ),
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: File(path).parent.path));
                      },
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('Compartir'),
                      ),
                      onTap: () {
                        shareFile(path, 'Cuentas Kiure',
                            'Archivo Encriptado de cuentas de Kiure');
                      },
                    )
                  ],
                ),
              );
            }),
        _buildDrawerItem(
          kyTheme: kyTheme,
          label: 'Eliminar bóveda',
          icon: const Icon(CupertinoIcons.delete),
          onTap: () {
            _showDeleteVaultConfirmDialog(context);
          },
        ),
        _buildDrawerItem(
            kyTheme: kyTheme,
            label: 'Donar :)',
            icon: const Icon(CupertinoIcons.heart),
            onTap: () {}),
      ],
    );
  }

  ContextMenuTileMolecule _buildDrawerItem(
      {required KyTheme kyTheme,
      required String label,
      required Widget icon,
      required Function() onTap}) {
    return ContextMenuTileMolecule(
        onTap: onTap,
        label: label,
        textStyle: TextStyle(color: kyTheme.colorOnBackground, fontSize: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        separation: 16,
        icon: icon);
  }

  void _showDeleteVaultConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Eliminar Bóveda',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Si eliminas la bóveda, se perderán todas las cuentas y grupos. ¿Deseas eliminarla?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('No')),
                  TextButton(
                      onPressed: () {
                        context.pop();
                        serviceLocator.getVaultService().deleteVault(false);
                        context.goNamed(KyRoutes.lockPage.name,
                            queryParameters: {'blockedByUser': 'true'});
                      },
                      child: const Text('Si')),
                ],
              )
            ],
          )),
    );
  }
}
