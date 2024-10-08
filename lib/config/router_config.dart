import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/data/utils/account_utils.dart';
import 'package:kyure/data/utils/group_utils.dart';
import 'package:kyure/presentation/pages/account_details/account_details_page.dart';
import 'package:kyure/presentation/pages/account_list/account_list_page.dart';
import 'package:kyure/presentation/pages/cloud_page/cloud_page.dart';
import 'package:kyure/presentation/pages/group_details/group_details_page.dart';
import 'package:kyure/presentation/pages/key_conflict_resolver/key_conflict_resolver_page.dart';
import 'package:kyure/presentation/pages/key_updater/key_updater_page.dart';
import 'package:kyure/presentation/pages/lock_page/lock_page.dart';
import 'package:kyure/services/service_locator.dart';

GlobalKey<NavigatorState> kiureNavigatorKey = GlobalKey();

final routerConfig = GoRouter(navigatorKey: kiureNavigatorKey, routes: [
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
      path: KyRoutes.cloudSettings.routePath,
      name: KyRoutes.cloudSettings.name,
      pageBuilder: (context, state) => const MaterialPage(
            child: CloudPage(),
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
              bool? editing =
                  state.uri.queryParameters['editing'] == 'true' ? true : null;
              int groupId =
                  int.parse(state.uri.queryParameters['groupId'] ?? '-1');
              return MaterialPage(
                  child: AccountDetailsPage(
                      editing: editing ?? id < 0,
                      account: id > 0
                          ? serviceLocator
                              .getVaultService()
                              .findAccountById(id)!
                          : Account.emptyWith(groupId: groupId)));
            }),
        GoRoute(
            path: KyRoutes.groupEditor.name,
            name: KyRoutes.groupEditor.name,
            pageBuilder: (context, state) {
              int id = int.parse(state.uri.queryParameters['id'] ?? '-1');
              AccountGroup group = id > 0
                  ? serviceLocator.getVaultService().findGroupById(id)!
                  : AccountGroupUtils.generateEmptyAccountGroup();
              return MaterialPage(
                  child: GroupDetailsPage(group: group, isNew: id < 0));
            }),
        GoRoute(
            path: KyRoutes.keyEditor.name,
            name: KyRoutes.keyEditor.name,
            pageBuilder: (context, state) {
              return const MaterialPage(child: KeyUpdaterPage());
            }),
        GoRoute(
            path: KyRoutes.keyConflictResolver.name,
            name: KyRoutes.keyConflictResolver.name,
            pageBuilder: (context, state) {
              return const MaterialPage(child: KeyConflictResolverPage());
            }),
      ]),
]);

enum KyRoutes {
  lockPage('/lock', '/lock'),
  main('/main', '/main'),
  accountEditor('account-editor', '/main/account-editor'),
  groupEditor('group-editor', '/main/group-editor'),
  keyEditor('key-editor', '/main/key-editor'),
  keyConflictResolver('key-conflict-resolver', '/main/key-conflict-resolver'),
  cloudSettings('cloud-settings', '/main/cloud-settings');

  const KyRoutes(this.name, this.routePath);

  final String name, routePath;
}
