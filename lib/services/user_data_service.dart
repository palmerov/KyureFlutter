import 'dart:io';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/data/models/user_data.dart';
import 'package:kyure/data/repositories/acount_data_repository.dart';
import 'package:kyure/data/utils/account_data_utils.dart';
import 'package:kyure/data/utils/encrypt_utils.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataService {
  late final AccountDataRepository accountDataRepository;
  UserData? userData;
  AccountsData? accountsData;
  String? path;
  String? key;
  bool isInit = false;
  late SharedPreferences prefs;

  UserDataService() {
    accountDataRepository = serviceLocator.getAccountDataRepository();
  }

  Future<void> _initPrefs() async {
    if (!isInit) {
      isInit = true;
      prefs = await SharedPreferences.getInstance();
    }
  }

  clear(){
    userData = null;
    accountsData = null;
    key = null;
  }

  Future<void> _processPath() async {
    await _initPrefs();
    if (Platform.isAndroid) {
      if (path == null) {
        path =
            '${(await getExternalStorageDirectories())!.first.path}/my_accounts.kiure';
      } else {
        path = (await File(path!).copy(
                '${(await getApplicationDocumentsDirectory()).path}/${path!.split('/').last}'))
            .path;
      }
    } else if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      path ??=
          '${(await getApplicationDocumentsDirectory()).path}/my_accounts.kiure';
    }
    prefs.setString('kiureFile', path!);
  }

  loadPrefs() async {
    await _initPrefs();
    path = prefs.getString('kiureFile');
  }

  Future<bool> evaluateFile() async {
    if (path == null) {
      return false;
    }
    if ((await File(path!).exists())) {
      return true;
    }
    return false;
  }

  Future<void> readUserData() async {
    try {
      userData = await accountDataRepository.readUserData(
          EncryptAlgorithm.AES, key!, File(path!));
      accountsData = userData!.accountsData;
      AccountDataUtils.createAllGroup(accountsData!);
    } catch (exception) {
      print(exception.toString());
      rethrow;
    }
  }

  Future<void> writeUserData() async {
    try {
      final userDataCopy = userData!.copyWith(
          accountsData: userData!.accountsData!
              .copyWith(accountGroups: accountsData!.accountGroups.sublist(1)));
      await accountDataRepository.writeUserData(
          EncryptAlgorithm.AES, key!, File(path!), userDataCopy);
    } catch (exception) {
      print(exception.toString());
      rethrow;
    }
  }

  Future<void> createNewFile() async {
    userData = UserData(
        version: 1,
        accountsData: AccountsData(accountGroups: []),
        datacrypt: '');
    AccountDataUtils.createAllGroup(userData!.accountsData!);
    accountsData = userData!.accountsData!;
    await _processPath();
    writeUserData();
  }

  void addNewAccount(Account account, AccountGroup group) {
    account.id = getMaxId() + 1;
    getAllGroup().accounts.insert(0, account);
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
    int i = accountsData!.accountGroups.sublist(1).indexWhere((element) =>
        element.accounts.indexWhere((element) => element.id == id) >= 0);
    if (i >= 0) {
      return accountsData!.accountGroups[i + 1];
    }
    return null;
  }

  AccountGroup getFirstRealGroup() {
    return accountsData!.accountGroups[1];
  }

  AccountGroup getAllGroup() {
    return accountsData!.accountGroups.first;
  }

  int getMaxId() {
    final group = getAllGroup();
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
    return accountsData!.accountGroups.sublist(1);
  }

  void deleteAccount(Account account) {
    final group = getGroupByAccountId(account.id)!;
    group.accounts.removeWhere((element) => element.id == account.id);
    getAllGroup().accounts.removeWhere((element) => element.id == account.id);
  }

  void deleteGroup(AccountGroup group) {
    accountsData!.accountGroups.removeWhere((element) => element == group);
    accountsData!.accountGroups.removeAt(0);
    AccountDataUtils.createAllGroup(accountsData!);
  }
}
