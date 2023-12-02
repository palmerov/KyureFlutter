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
    String text = await file.readAsString();
    Map<String, dynamic> json = jsonDecode(text);
    UserData userData = UserData.fromJson(json);
    userData.accountsData = AccountsData.fromJson(
        jsonDecode(EncryptUtils.decrypt(algorithm, key, userData.datacrypt)));
    return userData;
  }

  @override
  Future<void> writeUserData(EncryptAlgorithm algorithm, String key, File file,
      UserData userData) async {
    userData.datacrypt = EncryptUtils.encrypt(
        algorithm, key, jsonEncode(userData.accountsData!.toJson()));
    userData.version++;
    String strUserData = jsonEncode(userData);
    await file.writeAsString(strUserData);
  }
}

abstract class AccountDataRepository {
  Future<UserData> readUserData(
      EncryptAlgorithm algorithm, String key, File file);
  Future<void> writeUserData(
      EncryptAlgorithm algorithm, String key, File file, UserData userData);
}


/*
UserData userData = UserData(
        version: 1,
        datacrypt: '',
        accountsData: AccountsData(accountGroups: [
          AccountGroup(
              name: 'Social',
              color: const Color.fromARGB(255, 44, 124, 44).value,
              iconName: 'assets/svg_icons/groups_FILL0_wght300_GRAD-25_opsz24.svg',
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
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8', visible: false)),
                Account(
                    id: 2,
                    name: 'Facebook',
                    image: AccountImage(
                        path: 'assets/web_icons/facebook.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8', visible: false)),
                Account(
                    id: 3,
                    name: 'Instagram',
                    image: AccountImage(
                        path: 'assets/web_icons/instagram.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8', visible: false)),
                Account(
                    id: 4,
                    name: 'SnapChat',
                    image: AccountImage(
                        path: 'assets/web_icons/snapchat.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8', visible: false)),
                Account(
                    id: 5,
                    name: 'Youtube',
                    image: AccountImage(
                        path: 'assets/web_icons/youtube.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8', visible: false)),
                Account(
                    id: 6,
                    name: 'Pinterest',
                    image: AccountImage(
                        path: 'assets/web_icons/pinterest.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8', visible: false)),
                Account(
                    id: 7,
                    name: 'Behance',
                    image: AccountImage(
                        path: 'assets/web_icons/behance.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8', visible: false)),
                Account(
                    id: 8,
                    name: 'VK',
                    image: AccountImage(
                        path: 'assets/web_icons/vk.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8', visible: false)),
                Account(
                    id: 9,
                    name: 'Xiaomi',
                    image: AccountImage(
                        path: 'assets/web_icons/xiaomi.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8', visible: false)),
                Account(
                    id: 10,
                    name: 'Linkedin',
                    image: AccountImage(
                        path: 'assets/web_icons/linkedin.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8', visible: false)),
                Account(
                    id: 11,
                    name: 'Tiktok',
                    image: AccountImage(
                        path: 'assets/web_icons/tiktok.png',
                        source: ImageSource.assets),
                    fieldUsername:
                        AccountField(name: 'Username', data: 'palmero_valdes'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8', visible: false)),
                Account(
                    id: 12,
                    name: 'Google',
                    image: AccountImage(
                        path: 'assets/web_icons/google.png',
                        source: ImageSource.assets),
                    fieldUsername: AccountField(
                        name: 'Username', data: 'palmerovaldes99@gmail.com'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8', visible: false)),
              ]),
          AccountGroup(
              iconName:
                  'assets/svg_icons/account_balance_wallet_FILL0_wght300_GRAD-25_opsz24.svg',
              name: 'Pagos',
              color: const Color.fromARGB(255, 189, 109, 11).value,
              accounts: [
                Account(
                    id: 13,
                    name: 'BingX',
                    image: AccountImage(
                        path: 'assets/web_icons/bingx.png',
                        source: ImageSource.assets),
                    fieldUsername: AccountField(
                        name: 'Username', data: 'palmerovaldes99@gmail.com'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8', visible: false)),
                Account(
                    id: 14,
                    name: 'Tropipay',
                    image: AccountImage(
                        path: 'assets/web_icons/tropipay.jpg',
                        source: ImageSource.assets),
                    fieldUsername: AccountField(
                        name: 'Username', data: 'palmerovaldes99@gmail.com'),
                    fieldPassword:
                        AccountField(name: 'Password', data: 'uihE1-iu23{gd8', visible: false))
              ])
        ]));
    await Future.delayed(3.seconds);
    return Future.value(userData);

 */