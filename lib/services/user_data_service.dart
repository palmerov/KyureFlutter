import 'dart:convert';
import 'dart:io';

import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/data/models/user_data.dart';
import 'package:kyure/data/repositories/acount_data_repository.dart';
import 'package:kyure/data/utils/account_data_utils.dart';
import 'package:kyure/data/utils/encrypt_utils.dart';
import 'package:kyure/services/service_locator.dart';

class UserDataService {
  late final AccountDataRepository accountDataRepository;
  UserData? userData;
  AccountsData? accountsData;

  UserDataService() {
    accountDataRepository = serviceLocator.getAccountDataRepository();
  }

  Future<void> readUserData() async {
    try {
      userData = await accountDataRepository.readUserData(
          EncryptAlgorithm.AES, '', File(''));
      accountsData = userData!.accountsData;
      AccountDataUtils.createAllGroupIfMoreThan1(accountsData!);
    } catch (exception) {
      print(exception.toString());
      rethrow;
    }
  }

  Future<void> writeUserData() async {
    try {
      await accountDataRepository.writeUserData(
          EncryptAlgorithm.AES, '', File(''), userData!);
    } catch (exception) {
      print(exception.toString());
      rethrow;
    }
  }
}
