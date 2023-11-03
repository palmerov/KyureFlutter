import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/data/models/user_data.dart';
import 'package:kyure/data/utils/encrypt_utils.dart';

class AccountDataRepositoryImpl implements AccountDataRepository {
  @override
  Future<UserData> readUserData(
      EncryptAlgorithm algorithm, String key, File file) async {
    String strUserData = await file.readAsString();
    Map<String, dynamic> jsonUserData = jsonDecode(strUserData);
    UserData userData = UserData.fromJson(jsonUserData);
    String strAccountsData =
        EncryptUtils.decrypt(algorithm, key, userData!.datacrypt);
    Map<String, dynamic> jsonAccountsData = jsonDecode(strAccountsData);
    userData.accountsData = AccountsData.fromJson(jsonAccountsData);
    return userData;
  }

  @override
  Future<void> writeUserData(EncryptAlgorithm algorithm, String key, File file,
      UserData userData) async {
    String strAccountsData = jsonEncode(userData.accountsData!.toJson());
    String strDatacrypt = EncryptUtils.encrypt(algorithm, key, strAccountsData);
    userData.datacrypt = strDatacrypt;
    userData.version++;
    String strUserData = jsonEncode(userData);
    await file.writeAsString(strUserData);
  }
}

class AccountDataRepositoryMocked implements AccountDataRepository {
  @override
  Future<UserData> readUserData(
      EncryptAlgorithm algorithm, String key, File file) async {
    UserData userData = UserData(
        version: 1,
        datacrypt: '',
        accountsData: AccountsData(accountGroups: [
          AccountGroup(
              name: 'Social',
              color: const Color.fromARGB(255, 44, 124, 44).value,
              iconName: 'assets/group_icons/groups_black_24dp.svg',
              accounts: [
                Account(
                    id: 1,
                    name: 'Twitter',
                    image: AccountImage(
                        path: 'assets/web_icons/twitter.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8')),
                Account(
                    id: 1,
                    name: 'Facebook',
                    image: AccountImage(
                        path: 'assets/web_icons/facebook.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8')),
                Account(
                    id: 1,
                    name: 'Instagram',
                    image: AccountImage(
                        path: 'assets/web_icons/instagram.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8')),
                Account(
                    id: 1,
                    name: 'SnapChat',
                    image: AccountImage(
                        path: 'assets/web_icons/snapchat.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8')),
                Account(
                    id: 1,
                    name: 'Youtube',
                    image: AccountImage(
                        path: 'assets/web_icons/youtube.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8')),
                Account(
                    id: 1,
                    name: 'Pinterest',
                    image: AccountImage(
                        path: 'assets/web_icons/pinterest.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8')),
                Account(
                    id: 1,
                    name: 'Behance',
                    image: AccountImage(
                        path: 'assets/web_icons/behance.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8')),
                Account(
                    id: 1,
                    name: 'VK',
                    image: AccountImage(
                        path: 'assets/web_icons/vk.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8')),
                Account(
                    id: 1,
                    name: 'Xiaomi',
                    image: AccountImage(
                        path: 'assets/web_icons/xiaomi.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8')),
                Account(
                    id: 1,
                    name: 'Linkedin',
                    image: AccountImage(
                        path: 'assets/web_icons/linkedin.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8')),
                Account(
                    id: 1,
                    name: 'Tiktok',
                    image: AccountImage(
                        path: 'assets/web_icons/tiktok.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8')),
                Account(
                    id: 2,
                    name: 'Google',
                    image: AccountImage(
                        path: 'assets/web_icons/google.png',
                        source: ImageSource.assets),
                    fieldUsername: AccountField(
                        name: 'Username', data: 'palmerovaldes99@gmail.com'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8')),
              ]),
          AccountGroup(
              iconName:
                  'assets/group_icons/account_balance_wallet_black_24dp.svg',
              name: 'Pagos',
              color: const Color.fromARGB(255, 189, 109, 11).value,
              accounts: [
                Account(
                    id: 3,
                    name: 'BingX',
                    image: AccountImage(
                        path: 'assets/web_icons/bingx.png',
                        source: ImageSource.assets),
                    fieldUsername: AccountField(
                        name: 'Username', data: 'palmerovaldes99@gmail.com'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8')),
                Account(
                    id: 3,
                    name: 'Tropipay',
                    image: AccountImage(
                        path: 'assets/web_icons/tropipay.jpg',
                        source: ImageSource.assets),
                    fieldUsername: AccountField(
                        name: 'Username', data: 'palmerovaldes99@gmail.com'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8'))
              ])
        ]));
    await Future.delayed(10.seconds);
    return Future.value(userData);
  }

  @override
  Future<void> writeUserData(EncryptAlgorithm algorithm, String key, File file,
      UserData userData) async {
    await Future.delayed(1.seconds);
  }
}

abstract class AccountDataRepository {
  Future<UserData> readUserData(
      EncryptAlgorithm algorithm, String key, File file);
  Future<void> writeUserData(
      EncryptAlgorithm algorithm, String key, File file, UserData userData);
}
