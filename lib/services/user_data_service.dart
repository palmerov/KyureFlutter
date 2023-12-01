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

  void addNewAccount(Account account, AccountGroup group) {
    account.id = getMaxId() + 1;
    getAllGroup()?.accounts.insert(0, account);
    group.accounts.insert(0, account);
  }

  Account? findAccountById(int id) {
    try {
      for (var group in accountsData!.accountGroups) {
        return group.accounts.firstWhere((element) => element.id == id);
      }
    } catch (exception) {
      return null;
    }
    return null;
  }

  AccountGroup? getGroupByAccountId(int id) {
    if (accountsData!.accountGroups.length == 1) {
      return accountsData!.accountGroups.first;
    } else {
      int i = accountsData!.accountGroups.sublist(1).indexWhere((element) =>
          element.accounts.indexWhere((element) => element.id == id) >= 0);
      if (i >= 0) {
        return accountsData!.accountGroups[i + 1];
      }
      return null;
    }
  }

  AccountGroup getFirstRealGroup() {
    if (accountsData!.accountGroups.length == 1) {
      return accountsData!.accountGroups.first;
    } else {
      return accountsData!.accountGroups[1];
    }
  }

  AccountGroup? getAllGroup() {
    if (accountsData!.accountGroups.length == 1) return null;
    return accountsData!.accountGroups.first;
  }

  int getMaxId() {
    final group = getAllGroup() ?? getFirstRealGroup();
    return group.accounts.fold(
        0,
        (previousValue, element) =>
            previousValue > element.id ? previousValue : element.id);
  }

  AccountGroup? findGroupByName(String name) {
    return accountsData!.accountGroups
        .firstWhere((element) => element.name == name);
  }

  List<AccountGroup> getRealGroups() {
    return accountsData!.accountGroups.length == 1
        ? accountsData!.accountGroups
        : accountsData!.accountGroups.sublist(1);
  }

  void deleteAccount(Account account) {
    final group = getGroupByAccountId(account.id)!;
    group.accounts.removeWhere((element) => element.id == account.id);
    getAllGroup()?.accounts.removeWhere((element) => element.id == account.id);
  }
}
