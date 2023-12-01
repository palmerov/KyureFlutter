import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/presentation/pages/account_details/account_details_page.dart';
import 'package:kyure/presentation/pages/account_list/account_list_page.dart';
import 'package:kyure/services/service_locator.dart';

final routerConfig = GoRouter(routes: [
  GoRoute(
    path: '/',
    redirect: (context, state) => KyRoutes.main.routePath,
  ),
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
                              .getUserDataService()
                              .getGroupByAccountId(id)!
                          : serviceLocator
                              .getUserDataService()
                              .getFirstRealGroup(),
                      editing: editting?? id < 0,
                      account: id >= 0
                          ? serviceLocator
                              .getUserDataService()
                              .findAccountById(id)!
                          : Account(
                              id: -1,
                              name: '',
                              image: AccountImage(
                                  source: ImageSource.assets,
                                  path: 'assets/web_icons/squared.png'),
                              fieldUsername: AccountField(
                                  name: 'Nombre de usuario', data: ''),
                              fieldPassword:
                                  AccountField(name: 'Contraseña', data: ''))));
            })
      ]),
]);

enum KyRoutes {
  main('/main', '/main'),
  accountEditor('account-editor', '/main/account-editor');

  const KyRoutes(this.name, this.routePath);
  final String name, routePath;
}
