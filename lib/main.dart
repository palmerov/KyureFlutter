import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:kyure/config/router_config.dart';
import 'package:kyure/presentation/pages/account_list/account_list_page.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:kyure/services/service_locator.dart';

void main() {
  serviceLocator.registerAll();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return KyTheme(
      theme: ThemeData.light(),
      child: MaterialApp.router(
        title: 'Flutter Demo',
        builder: BotToastInit(),
        theme: KyTheme.lightTheme,
        routerConfig: routerConfig,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
