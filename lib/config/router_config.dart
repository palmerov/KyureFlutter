import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kyure/presentation/pages/account_details/account_details_page.dart';
import 'package:kyure/presentation/pages/account_list/account_list_page.dart';

final routerConfig = GoRouter(routes: [
  GoRoute(
    path: '/',
    redirect: (context, state) => KyRoutes.main.routePath,
  ),
  GoRoute(
      path: KyRoutes.main.routePath,
      name: KyRoutes.main.name,
      pageBuilder: (context, state) =>
          const MaterialPage(child: AccountListPage()),
      routes: [
        GoRoute(
            path: KyRoutes.accountEditor.name,
            name: KyRoutes.accountEditor.name,
            pageBuilder: (context, state) =>
                const MaterialPage(child: AccountDetailsPage()))
      ]),
]);

enum KyRoutes {
  main('/main', '/main'),
  accountEditor('account-editor', '/main/account-editor');

  const KyRoutes(this.name, this.routePath);
  final String name, routePath;
}
