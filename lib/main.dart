import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: KyTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: KyTheme(theme: Theme.of(context), child: const AccountListPage()),
    );
  }
}
