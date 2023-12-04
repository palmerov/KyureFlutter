import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/data/models/vault.dart';
import 'package:kyure/data/repositories/acount_data_repository.dart';
import 'package:kyure/data/utils/account_data_utils.dart';
import 'package:kyure/data/utils/encrypt_utils.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SortMethod { nameAsc, nameDesc, noOrder, creationAsc, creationDesc }

class KiureService {
  late final String _rootPath, _rootVaults, _rootImages;
  late final AccountDataRepository accountDataRepository;
  late SharedPreferences _prefs;
  List<String> _vaultNames = [];
  bool initialized = false;

  VaultData? _vault;
  Vault? _userData;
  String? _vaultName;
  String? _key;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> init() async {
    if (initialized) return;
    initialized = true;

    _rootPath = '${(await getApplicationDocumentsDirectory()).path}kiure';
    Directory(_rootPath).createSync(recursive: true);
    _rootVaults = '$_rootPath/vaults';
    Directory(_rootVaults).createSync(recursive: true);
    _rootImages = '$_rootPath/images';
    Directory(_rootImages).createSync(recursive: true);

    // init repo
    accountDataRepository = serviceLocator.getAccountDataRepository();
    accountDataRepository.init(_rootVaults);

    // prefs
    _vaultName = _prefs.getString('vaultName');

    // vault names
    _vaultNames = await accountDataRepository.getVaultNames();
  }

  set vaultName(String? name) {
    _vaultName = name;
    if (name == null) {
      _prefs.remove('vaultName');
    } else {
      _prefs.setString('vaultName', name);
    }
  }

  set brigtnessLight(bool light) => _prefs.setBool('light', light);

  bool get brigtnessLight => _prefs.getBool('light') ?? true;

  void clear() {
    _vault = null;
    _key = null;
  }

  String? get vaultName => _vaultName;

  List<String> get vaultNames => _vaultNames;

  VaultData get vault => _vault!;

  set key(String? key) {
    _key = key;
  }

  bool existVault(String vaultName) {
    return _vaultNames.contains(vaultName);
  }

  Future<void> openVault(String vaultName, String key) async {
    _vaultName = vaultName;
    _key = key;
    await readVaultData();
  }

  Future<void> readVaultData() async {
    try {
      _userData = await accountDataRepository.readUserData(
          EncryptAlgorithm.AES, _key!, _vaultName!);
      _vault = _userData!.accountsData;
      AccountDataUtils.createAllGroup(_vault!);
    } catch (exception) {
      print(exception.toString());
      rethrow;
    }
  }

  Future<void> writeVaultData() async {
    try {
      final userDataCopy = _userData!.copyWith(
          accountsData: _userData!.accountsData!
              .copyWith(accountGroups: _vault!.accountGroups.sublist(1)));
      await accountDataRepository.writeUserData(
          EncryptAlgorithm.AES, _key!, _vaultName!, userDataCopy);
    } catch (exception) {
      print(exception.toString());
      rethrow;
    }
  }

  Future<void> createNewVault(String vaultName) async {
    _vaultName = vaultName;
    _userData = Vault(
        version: 1,
        vaultName: vaultName,
        accountsData: VaultData(accountGroups: []),
        datacrypt: '');
    AccountDataUtils.createAllGroup(_userData!.accountsData!);
    _vault = _userData!.accountsData!;
    _vaultNames.add(vaultName);
    writeVaultData();
  }

  Future<bool> importVault(File file) async {
    try {
      final vault = Vault.fromJson(jsonDecode(file.readAsStringSync()));
      final vaultName = vault.vaultName;
      if (_vaultNames.contains(vaultName)) {
        final currentFile = accountDataRepository.getVaultFile(vaultName);
        final currentUserData =
            Vault.fromJson(jsonDecode(currentFile.readAsStringSync()));
        if (currentUserData.version >= vault.version) {
          return false;
        }
      }
      await file.copy(accountDataRepository.getVaultFile(vaultName).path);
      _vaultNames.add(vault.vaultName);
      this.vaultName = vaultName;
      return true;
    } catch (exception) {
      rethrow;
    }
  }

  void deleteVault() {
    accountDataRepository.getVaultFile(vaultName!).deleteSync();
    _vaultNames.remove(_vaultName);
    _vault = null;
    _vaultName = null;
    _key = null;
  }

  void addNewAccount(Account account, AccountGroup group) {
    account.id = getMaxId() + 1;
    getAllGroup().accounts.insert(0, account);
    group.accounts.insert(0, account);
  }

  Account? findAccountById(int id) {
    try {
      for (var group in _vault!.accountGroups) {
        return group.accounts.firstWhere((element) => element.id == id);
      }
    } catch (exception) {
      return null;
    }
    return null;
  }

  AccountGroup? getGroupByAccountId(int id) {
    int i = _vault!.accountGroups.sublist(1).indexWhere((element) =>
        element.accounts.indexWhere((element) => element.id == id) >= 0);
    if (i >= 0) {
      return _vault!.accountGroups[i + 1];
    }
    return null;
  }

  AccountGroup getFirstRealGroup() {
    return _vault!.accountGroups[1];
  }

  AccountGroup getAllGroup() {
    return _vault!.accountGroups.first;
  }

  int getMaxId() {
    final group = getAllGroup();
    return group.accounts.fold(
        0,
        (previousValue, element) =>
            previousValue > element.id ? previousValue : element.id);
  }

  AccountGroup? findGroupByName(String name) {
    int index =
        _vault!.accountGroups.indexWhere((element) => element.name == name);
    if (index >= 0) {
      return _vault!.accountGroups[index];
    }
    return null;
  }

  List<AccountGroup> getRealGroups() {
    return _vault!.accountGroups.sublist(1);
  }

  void deleteAccount(Account account) {
    final group = getGroupByAccountId(account.id)!;
    group.accounts.removeWhere((element) => element.id == account.id);
    getAllGroup().accounts.removeWhere((element) => element.id == account.id);
  }

  void deleteGroup(AccountGroup group) {
    _vault!.accountGroups.removeWhere((element) => element == group);
    _vault!.accountGroups.removeAt(0);
    AccountDataUtils.createAllGroup(_vault!);
  }

  Future<String> exportFile() async {
    Directory dir = Platform.isAndroid
        ? (await getExternalStorageDirectory())!
        : await getApplicationDocumentsDirectory();
    String savePath = '${dir.path}exp_accounts_${DateTime.now()}.kiure';
    await accountDataRepository.getVaultFile(vaultName!).copy(savePath);
    return savePath;
  }

  void sort(int groupIndex, SortMethod method) {
    final group = _vault!.accountGroups[groupIndex];
    switch (method) {
      case SortMethod.nameDesc:
        {
          group.accounts.sort((a, b) => a.name.compareTo(b.name));
          break;
        }
      case SortMethod.nameAsc:
        {
          group.accounts.sort((a, b) => b.name.compareTo(a.name));
          break;
        }
      case SortMethod.noOrder:
        {
          if (groupIndex == 0) {
            _vault!.accountGroups.removeAt(0);
            AccountDataUtils.createAllGroup(_vault!);
          } else {}
          break;
        }
      case SortMethod.creationAsc:
        {
          group.accounts.sort((a, b) => a.id.compareTo(b.id));
          break;
        }
      case SortMethod.creationDesc:
        {
          {
            group.accounts.sort((a, b) => b.id.compareTo(a.id));
            break;
          }
        }
    }
  }
}
