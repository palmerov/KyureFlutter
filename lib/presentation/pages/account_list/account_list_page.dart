import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/config/router_config.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/presentation/pages/account_list/account_list_bloc.dart';
import 'package:kyure/presentation/widgets/molecules/account_group.dart';
import 'package:kyure/presentation/widgets/molecules/account_group_list_shimmer.dart';
import 'package:kyure/presentation/widgets/molecules/account_item.dart';
import 'package:kyure/presentation/widgets/molecules/account_list_shimmer.dart';
import 'package:kyure/presentation/widgets/molecules/context_menu_tile.dart';
import 'package:kyure/presentation/widgets/molecules/image_rounded.dart';
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
                      image: Image.asset(account.image.path),
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
                      bloc.reload();
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
      bloc.reload();
    }
  }

  void _showOrderDialog() {}

  @override
  Widget build(BuildContext context) {
    final wsizeP = MediaQuery.of(context).size;
    final kyTheme = KyTheme.of(context)!;
    AccountListPageBloc bloc = BlocProvider.of<AccountListPageBloc>(context);
    final bool isPcScreen = MediaQuery.of(context).size.width > 600;
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
                              onPageChanged: (value) => {
                                if (bloc.listenPageView) bloc.selectGroup(value)
                              },
                              itemBuilder: (context, groupIndex) => Center(
                                child: BlocBuilder<AccountListPageBloc,
                                    AccountListPageState>(
                                  buildWhen: (previous, current) =>
                                      previous.version != current.version || current is AccountListPageFilteredState,
                                  builder: (context, state) {
                                    return ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      padding: const EdgeInsets.only(
                                          top: 100, bottom: 60),
                                      itemBuilder: (context, accountIndex) {
                                        Account account = state
                                            .accountGroups[groupIndex]
                                            .accounts[accountIndex];
                                        return AccountItemMolecule(
                                          account: account,
                                          onTap: () => _openAccountDetails(
                                              bloc, context, account, false),
                                          onLongTap: () =>
                                              _showAccountContextMenuDialog(
                                                  bloc, context, account),
                                        );
                                      },
                                      itemCount: state.accountGroups.isEmpty
                                          ? 0
                                          : state.accountGroups[groupIndex]
                                              .accounts.length,
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
                                      keyScaffold.currentState!.openDrawer();
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
                                  height: 34,
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
                                      return ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, groupIndex) {
                                          final group =
                                              state.accountGroups[groupIndex];
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
                            child: ColoredBox(
                                color: kyTheme.colorOnBackgroundOpacity30),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ItemAction(
                                      icon: Icon(CupertinoIcons.lock,
                                          color: kyTheme
                                              .colorOnBackgroundOpacity60),
                                      text: 'Bloquear',
                                      onTap: () {
                                        context.goNamed(KyRoutes.lockPage.name,
                                            queryParameters: {
                                              'blockedByUser': 'true'
                                            });
                                        serviceLocator
                                            .getUserDataService()
                                            .clear();
                                      },
                                    ),
                                    ItemAction(
                                      icon: Icon(CupertinoIcons.list_number,
                                          color: kyTheme
                                              .colorOnBackgroundOpacity60),
                                      text: 'Orden',
                                      onTap: () {
                                        _showOrderDialog();
                                      },
                                    ),
                                    ItemAction(
                                      icon: Icon(
                                          CupertinoIcons
                                              .rectangle_on_rectangle_angled,
                                          color: kyTheme
                                              .colorOnBackgroundOpacity60),
                                      text: '+ Grupo',
                                      onTap: () async {
                                        final saved = await context.pushNamed(
                                            KyRoutes.groupEditor.name);
                                        if (saved != null && (saved as bool)) {
                                          bloc.reload();
                                        }
                                      },
                                    ),
                                    ItemAction(
                                      icon: Icon(CupertinoIcons.person,
                                          color: kyTheme
                                              .colorOnBackgroundOpacity60),
                                      text: '+ Cuenta',
                                      onTap: () async {
                                        if (serviceLocator
                                                .getUserDataService()
                                                .accountsData!
                                                .accountGroups
                                                .length ==
                                            1) {
                                          _showYesOrNoDialog(
                                              context,
                                              'No hay grupos',
                                              'Para crear una cuenta, debes tener al menos un grupo además de "Todos". ¿Continuar y crear uno?',
                                              () async {
                                            final saved =
                                                await context.pushNamed(
                                                    KyRoutes.groupEditor.name);
                                            if (saved != null &&
                                                (saved as bool)) {
                                              bloc.reload();
                                            }
                                          }, () => null);
                                        } else {
                                          final result =
                                              await context.pushNamed(
                                                  KyRoutes.accountEditor.name);
                                          if (result != null &&
                                              (result as bool)) bloc.reload();
                                        }
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
  });
  final bool isPcScreen;

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    return NavigationDrawer(
      elevation: isPcScreen ? 2 : 8,
      children: [
        const SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Kyure',
                style: TextStyle(fontSize: 18),
              ),
              Text('Asegura tus cuentas'),
            ],
          ),
        ),
        _buildDrawerItem(
            kyTheme: kyTheme,
            onTap: () {},
            label: 'Configuraciones',
            icon: const Icon(CupertinoIcons.settings)),
        _buildDrawerItem(
            kyTheme: kyTheme,
            label: 'Exportar cuentas',
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
        textStyle: TextStyle(color: kyTheme.colorToastText, fontSize: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        separation: 16,
        icon: icon);
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
