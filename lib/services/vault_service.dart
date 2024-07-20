import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:kyure/config/values.dart';
import 'package:kyure/data/models/vault.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/data/models/vault_register.dart';
import 'package:kyure/data/repositories/data_provider.dart';
import 'package:kyure/data/repositories/local/local_data_provider.dart';
import 'package:kyure/data/utils/account_utils.dart';
import 'package:kyure/data/utils/encrypt_utils.dart';
import 'package:kyure/data/utils/file_utils.dart';
import 'package:kyure/data/utils/group_utils.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:kyure/services/version/vault_version_system_service.dart';

class VaultService {
  late VaultVersionSystemService vaultVersionSystemService;
  late LocalDataProvider localDataProvider;
  DataProvider? remoteDataProvider;
  List<VaultRegister> _localVaultRegisters = [];
  List<VaultRegister>? _remoteVaultRegisters;

  String? _key;
  String? _vaultName;
  EncryptAlgorithm? _algorithm;
  Vault? _vault;
  VaultData? _vaultData;

  List<AccountGroup>? _groups;
  List<Account>? _accounts;

  bool get isOpen => _vault != null;

  List<AccountGroup>? get groups => _groups;

  List<Account>? get accounts => _accounts;

  String? get vaultName => _vaultName;

  set key(String? key) => _key = key;

  get localVaultRegisters => _localVaultRegisters;

  set vaultName(String? name) => _vaultName = name;

  get localVaultNames => _localVaultRegisters.map((e) => e.name).toList();

  init(String localPath) async {
    vaultVersionSystemService = VaultVersionSystemService();
    // local
    localDataProvider = serviceLocator.getLocalDataProvider();
    await localDataProvider.init(localPath);
    _localVaultRegisters = await localDataProvider.listVaults();
    if (_localVaultRegisters.isNotEmpty) {
      _vaultName = _localVaultRegisters[0].name;
    }

    try {
      remoteDataProvider = serviceLocator.getRemoteDataProvider(RemoteProviders.Dropbox);
      if (remoteDataProvider != null) {
        await remoteDataProvider!.init(localPath);
      }
    } catch (e) {}
  }

  bool existVaultInLocal(String vaultName) {
    return _localVaultRegisters
        .where((element) => element.name == vaultName)
        .isNotEmpty;
  }

  bool existVaultInRemote(String vaultName) {
    _fetchRemoteVaultRegisters();
    return (_remoteVaultRegisters ?? [])
        .where((element) => element.name == vaultName)
        .isNotEmpty;
  }

  Future<File?> tryToImportVaultFile(File file) async {
    final localFile =  await localDataProvider.tryToImportVaultFromFile(file);
    if (localFile != null) {
      await _fetchLocalVaultRegisters();
      return localFile;
    }
    return null;
  }

  bool existVaultFileInLocal(File file) {
    return existVaultInLocal(getVaultNameFromFile(file));
  }

  String getVaultNameFromFile(File file) {
    Vault vault = Vault.fromJson(
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>);
    return vault.vaultName;
  }

  _fetchRemoteVaultRegisters() async {
    _remoteVaultRegisters = await remoteDataProvider?.listVaults();
  }

  _fetchLocalVaultRegisters() async {
    _localVaultRegisters = await localDataProvider.listVaults();
  }

  Future<void> openVault(
      String vaultName, EncryptAlgorithm algorithm, String key) async {
    _vaultName = vaultName;
    _key = key;
    _algorithm = algorithm;
    await _readVaultData();
  }

  void sort(SortBy method, [bool save = true]) {
    switch (method) {
      case SortBy.nameDesc:
        _accounts!.sort((a, b) => a.name.compareTo(b.name));
        _groups!.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortBy.nameAsc:
        _accounts!.sort((a, b) => b.name.compareTo(a.name));
        _groups!.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortBy.modifDateDesc:
        _accounts!.sort((a, b) => a.id.compareTo(b.id));
        _groups!.sort((a, b) => a.id.compareTo(b.id));
        break;
      case SortBy.modifDateAsc:
        _accounts!.sort((a, b) => b.id.compareTo(a.id));
        _groups!.sort((a, b) => b.id.compareTo(a.id));
        break;
    }
    saveVaultData(false, true);
  }

  File getVaultFile() {
    return File(concatPath(
        localDataProvider.rootVaultDir.path,
        _localVaultRegisters
            .firstWhere((element) => element.name == _vaultName)
            .path));
  }

  void closeVault() {
    _vault = null;
    _vaultData = null;
    _vaultName = null;
    _key = null;
  }

  Future<void> _readVaultData() async {
    try {
      _vault =
          await localDataProvider.readVault(_algorithm!, _key!, _vaultName!);
      _vaultData = _vault!.data;
      _accounts = _vaultData!.accounts.values.toList();
      _groups = _vaultData!.groups.values.toList();
      sort(_vaultData!.sort, false);
    } catch (exception) {
      print(exception.toString());
      rethrow;
    }
  }

  Future<void> saveVaultData(bool updateVault, bool updateVaultData) async {
    try {
      if (updateVault) {
        _vault!.modifDate = DateTime.now();
      }
      if (updateVaultData) {
        _vaultData!.modifDate = DateTime.now();
      }
      await localDataProvider.writeVault(
          _algorithm!, _key!, _vaultName!, _vault!);
    } catch (exception) {
      print(exception.toString());
      rethrow;
    }
  }

  bool hasToSync() {
    if (_remoteVaultRegisters == null) return false;
    bool existRemoteVault =
        (_remoteVaultRegisters?.any((element) => element.name == _vaultName) ??
            false);
    bool outOfDateWithRemote = (_remoteVaultRegisters?.any((element) =>
            element.name == _vaultName &&
            element.modifDate != _vault!.modifDate) ??
        false);
    return !existRemoteVault || outOfDateWithRemote;
  }

  Future<void> createNewVault(
      String vaultName, EncryptAlgorithm algorithm, String key) async {
    _vaultName = vaultName;
    _key = key;
    _algorithm = algorithm;
    _vault = Vault(
        modifDate: DateTime.now(),
        vaultName: vaultName,
        data: VaultData(
            accounts: {},
            deletedAccounts: {},
            groups: {-1: GROUP_ALL.copyWith()},
            deletedGroups: {},
            modifDate: DateTime.now(),
            sort: SortBy.modifDateDesc),
        datacrypt: '');
    _vaultData = _vault!.data!;
    _accounts = [];
    _groups = _vaultData!.groups.values.toList();
    saveVaultData(false, false);
  }

  Future<SyncResult> syncWithFile(String? fileVaultKey, File file) async {
    try {
      fileVaultKey ??= _key;
      Vault fileEncryptedVault =
          Vault.fromJson(jsonDecode(file.readAsStringSync()));
      if (fileEncryptedVault.vaultName != _vaultName) {
        return SyncResult.incompatible;
      }
      try {
        final fileVault = await localDataProvider.decryptVault(
            _algorithm!, fileVaultKey!, fileEncryptedVault);
        await mergeVault(fileVault, fileVaultKey);
      } on InvalidKeyException {
        return SyncResult.wrongRemoteKey;
      }
      return SyncResult.success;
    } catch (exception) {
      log(exception.toString());
      return SyncResult.accessError;
    }
  }

  Future<SyncResult> syncWithRemote(String? remoteKey) async {
    try {
      await _fetchRemoteVaultRegisters();
      if (_remoteVaultRegisters == null) return SyncResult.accessError;
      remoteKey ??= _key;
      bool existRemoteVault = (_remoteVaultRegisters
              ?.any((element) => element.name == _vaultName) ??
          false);
      bool outOfDateWithRemote = (_remoteVaultRegisters?.any((element) =>
              element.name == _vaultName &&
              element.modifDate != _vault!.modifDate) ??
          false);
      if (!existRemoteVault || outOfDateWithRemote) {
        if (existRemoteVault) {
          Vault? remoteVault;
          try {
            remoteVault = await remoteDataProvider?.readVault(
                _algorithm!, _key!, _vaultName!);
          } on AccessibilityException {
            return SyncResult.accessError;
          } on InvalidKeyException {
            return SyncResult.wrongRemoteKey;
          }
          if (remoteVault != null) {
            final updateDirection = await mergeVault(remoteVault, remoteKey!);
            if (updateDirection == UpdateDirection.toRemote ||
                updateDirection == UpdateDirection.toRemoteAndLocal) {
              await remoteDataProvider?.writeVault(
                  _algorithm!, _key!, _vaultName!, _vault!);
            }
          } else {
            return SyncResult.accessError;
          }
        } else {
          await remoteDataProvider?.writeVault(
              _algorithm!, _key!, _vaultName!, _vault!);
          return SyncResult.success;
        }
      }
      return SyncResult.success;
    } catch (exception) {
      log(exception.toString());
      return SyncResult.accessError;
    }
  }

  Future<UpdateDirection> mergeVault(
      Vault decryptedVault, String vaultKey) async {
    try {
      final vaultName = decryptedVault.vaultName;
      if (vaultName == _vaultName) {
        UpdateDirection updateDirection;
        VaultData mergedVaultData;
        (mergedVaultData, updateDirection) = await vaultVersionSystemService
            .getMergedData(_vaultData!, decryptedVault.data!);
        bool updatekey = decryptedVault.modifDate
            .isAfter(_vault!.modifDate); // has the incomming vault a newer key?
        if (updateDirection == UpdateDirection.toLocal ||
            updateDirection == UpdateDirection.toRemoteAndLocal ||
            updatekey) {
          _vaultData = mergedVaultData;
          _vault!.data = mergedVaultData;
          if (updatekey) {
            // update the current vault key with the newer
            _key = vaultKey;
            _vault!.modifDate = decryptedVault.modifDate;
          }
          await saveVaultData(false, false);
        }
        return updateDirection;
      }
    } catch (exception) {
      rethrow;
    }
    return UpdateDirection.noUpdate;
  }

  void deleteVault(bool remote) async {
    await localDataProvider.deleteVault(_vaultName!);
    if (remote) {
      await remoteDataProvider?.deleteVault(_vaultName!);
    }
    await _fetchLocalVaultRegisters();
    _vaultData = null;
    _vaultName = null;
    _key = null;
  }

  Future<bool> addNewAccount(Account account) async {
    bool insert = AccountUtils.assignId(account, _vaultData!.accounts);
    if (!insert) return false;
    _vaultData!.accounts[account.id] = account;
    // if exists in deletted accounts, remove from there
    String simpleName = AccountUtils.simplifyName(account);
    _vaultData!.deletedAccounts.removeWhere((key, value) =>
        AccountUtils.simplifyName(value) == simpleName &&
        value.fieldUsername.data == account.fieldUsername.data);
    _accounts!.add(account);
    await saveVaultData(false, true);
    return true;
  }

  Future<bool> addNewGroup(AccountGroup group) async {
    bool insert = AccountGroupUtils.assignId(group, _vaultData!.groups);
    if (!insert) return false;
    _vaultData!.groups[group.id] = group;
    // if exists in deletted groups, remove from there
    String simpleName = group.name.trim().toLowerCase();
    _vaultData!.deletedGroups.removeWhere(
        (key, value) => value.name.trim().toLowerCase() == simpleName);
    _groups!.add(group);
    await saveVaultData(false, true);
    return true;
  }

  Future updateKey(String key) async {
    _key = key;
    await saveVaultData(true, false);
  }

  Account? findAccountById(int accountId) {
    return _vaultData!.accounts[accountId];
  }

  AccountGroup? findGroupById(int groupId) {
    return _vaultData!.groups[groupId];
  }

  AccountGroup? findGroupByName(String name) {
    name = name.trim().toLowerCase();
    for (var group in groups!) {
      if (group.name.trim().toLowerCase() == name) {
        return group;
      }
    }
    return null;
  }

  void deleteAccount(Account account) {
    account.status = LifeStatus.deleted;
    _vaultData!.accounts.remove(account.id);
    _vaultData!.deletedAccounts[account.id] = account;
    _accounts!
        .removeAt(_accounts!.indexWhere((element) => account.id == element.id));
    saveVaultData(false, true);
  }

  void deleteGroup(AccountGroup group) {
    group.status = LifeStatus.deleted;
    _vaultData!.groups.remove(group.id);
    _vaultData!.deletedGroups[group.id] = group;
    _groups!.removeAt(_groups!.indexWhere((element) => group.id == element.id));
    saveVaultData(false, true);
  }
}

enum SyncResult { accessError, wrongRemoteKey, incompatible, success }
