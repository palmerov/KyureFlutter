import 'dart:convert';
import 'dart:io';

import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/data/models/user_data.dart';
import 'package:kyure/data/utils/encrypt_utils.dart';

class UserDataService {
  UserData? userData;
  AccountsData? accountsData;

  void readUserData(EncryptAlgorithm algorithm, String key, File file) async {
    String strUserData = await file.readAsString();
    Map<String, dynamic> jsonUserData = jsonDecode(strUserData);
    userData = UserData.fromJson(jsonUserData);
    String strAccountsData =
        EncryptUtils.decrypt(algorithm, key, userData!.datacrypt);
    Map<String, dynamic> jsonAccountsData = jsonDecode(strAccountsData);
    accountsData = AccountsData.fromJson(jsonAccountsData);
  }

  void writeUserData(EncryptAlgorithm algorithm, String key, File file) async {
    String strAccountsData = jsonEncode(accountsData);
    String strDatacrypt = EncryptUtils.encrypt(algorithm, key, strAccountsData);
    userData = UserData(
      version: userData!.version + 1,
      datacrypt: strDatacrypt,
    );
    String strUserData = jsonEncode(userData);
    await file.writeAsString(strUserData);
  }
}
