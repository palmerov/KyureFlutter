import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/presentation/pages/account_details/account_details_page.dart';
import 'package:kyure/presentation/pages/account_list/account_list_page.dart';
import 'package:kyure/presentation/pages/group_details/group_details_page.dart';
import 'package:kyure/presentation/pages/key_updater/key_updater_page.dart';
import 'package:kyure/presentation/pages/lock_page/lock_page.dart';
import 'package:kyure/services/service_locator.dart';

final routerConfig = GoRouter(routes: [
  GoRoute(
    path: '/',
    redirect: (context, state) => KyRoutes.lockPage.routePath,
  ),
  GoRoute(
      path: KyRoutes.lockPage.routePath,
      name: KyRoutes.lockPage.name,
      pageBuilder: (context, state) => MaterialPage(
            child: LockPage(
                blockedByUser:
                    (state.uri.queryParameters['blockedByUser'] ?? 'false') ==
                        'true'),
          )),
  GoRoute(
      path: KyRoutes.main.routePath,
      name: KyRoutes.main.name,
      pageBuilder: (context, state) => const MaterialPage(
              child: Scaffold(
            body: Center(child: AccountListPage()),
          )),
      routes: [
        GoRoute(
            path: KyRoutes.accountEditor.name,
            name: KyRoutes.accountEditor.name,
            pageBuilder: (context, state) {
              int id = int.parse(state.uri.queryParameters['id'] ?? '-1');
              bool? editting =
                  state.uri.queryParameters['editting'] == 'true' ? true : null;
              return MaterialPage(
                  child: AccountDetailsPage(
                      group: id >= 0
                          ? serviceLocator
                              .getKiureService()
                              .getGroupByAccountId(id)!
                          : serviceLocator
                              .getKiureService()
                              .getFirstRealGroup(),
                      editing: editting ?? id < 0,
                      account: id >= 0
                          ? serviceLocator
                              .getKiureService()
                              .findAccountById(id)!
                          : Account(
                              id: -1,
                              name: '',
                              image: AccountImage(
                                  source: ImageSource.assets,
                                  path: 'assets/web_icons/squared.png'),
                              fieldUsername: AccountField(
                                  name: 'Nombre de usuario', data: ''),
                              fieldPassword: AccountField(
                                  name: 'Contraseña',
                                  data: '',
                                  visible: false))));
            }),
        GoRoute(
            path: KyRoutes.groupEditor.name,
            name: KyRoutes.groupEditor.name,
            pageBuilder: (context, state) {
              String? name = state.uri.queryParameters['name'];
              AccountGroup group = name != null
                  ? serviceLocator.getKiureService().findGroupByName(name)!
                  : AccountGroup(
                      iconName:
                          'assets/svg_icons/palette_FILL0_wght300_GRAD-25_opsz24.svg',
                      name: '',
                      color: Colors.blue.shade700.value,
                      accounts: []);
              bool? editting =
                  state.uri.queryParameters['editting'] == 'true' ? true : null;
              return MaterialPage(
                  child: GroupDetailsPage(group: group, isNew: name == null));
            }),
        GoRoute(
            path: KyRoutes.keyEditor.name,
            name: KyRoutes.keyEditor.name,
            pageBuilder: (context, state) {
              return const MaterialPage(child: KeyUpdaterPage());
            }),
      ]),
]);

enum KyRoutes {
  lockPage('/lock', '/lock'),
  main('/main', '/main'),
  accountEditor('account-editor', '/main/account-editor'),
  groupEditor('group-editor', '/main/group-editor'),
  keyEditor('key-editor', '/main/key-editor');

  const KyRoutes(this.name, this.routePath);
  final String name, routePath;
}
