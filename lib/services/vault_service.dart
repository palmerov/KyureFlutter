import 'dart:developer';
import 'dart:io';

import 'package:kyure/data/models/vault.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/data/models/vault_register.dart';
import 'package:kyure/data/repositories/data_provider.dart';
import 'package:kyure/data/repositories/local_data_provider.dart';
import 'package:kyure/data/repositories/remote_data_provider.dart';
import 'package:kyure/data/utils/account_utils.dart';
import 'package:kyure/data/utils/encrypt_utils.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:kyure/services/version/vault_version_system_service.dart';

class VaultService {
  late final VaultVersionSystemService vaultVersionSystemService;
  late final LocalDataProvider localDataProvider;
  late final DataProvider? remoteDataProvider;
  late final List<VaultRegister> _localVaultRegisters;
  late final List<VaultRegister>? _remoteVaultRegisters;

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

  void init(String localPath, RemoteInitData? remoteInitData) async {
    // local
    localDataProvider = serviceLocator.getLocalDataProvider();
    await localDataProvider.init(localPath);
    _localVaultRegisters = await localDataProvider.listVaults();

    remoteDataProvider = serviceLocator.getRemoteDataProvider();
    if (remoteDataProvider != null) {
      await remoteDataProvider!.init(localPath);
    }
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
    _accounts = _vaultData!.accounts.values.toList();
    _groups = _vaultData!.groups.values.toList();
    sort(_vaultData!.sort);
    await _readVaultData();
  }

  void sort(SortBy method) {
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
  }

  File getVaultFile() {
    return File(
        '${localDataProvider.rootDir.path}${_localVaultRegisters.firstWhere((element) => element.name == _vaultName).path}');
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
    } catch (exception) {
      print(exception.toString());
      rethrow;
    }
  }

  Future<void> saveVaultData() async {
    try {
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

  Future<void> createNewVault(String vaultName) async {
    _vaultName = vaultName;
    _vault = Vault(
        modifDate: DateTime.now(),
        vaultName: vaultName,
        data: VaultData(
            accounts: {},
            deletedAccounts: {},
            groups: {},
            deletedGroups: {},
            modifDate: DateTime.now(),
            sort: SortBy.modifDateDesc),
        datacrypt: '');
    _vaultData = _vault!.data!;
    saveVaultData();
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
            final updateDirection = await mergeVault(remoteVault);
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
          return SyncResult.upToDate;
        }
      }
      return SyncResult.upToDate;
    } catch (exception) {
      log(exception.toString());
      return SyncResult.accessError;
    }
  }

  Future<UpdateDirection> mergeVault(Vault vault) async {
    try {
      final vaultName = vault.vaultName;
      if (vaultName == _vaultName) {
        UpdateDirection updateDirection;
        VaultData mergedVaultData;
        (mergedVaultData, updateDirection) = await vaultVersionSystemService
            .getMergedData(_vaultData!, vault.data!);
        if (updateDirection == UpdateDirection.toLocal ||
            updateDirection == UpdateDirection.toRemoteAndLocal) {
          _vaultData = mergedVaultData;
          _vault!.data = mergedVaultData;
          await saveVaultData();
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
    if (!insert) return Future.value(false);
    _vaultData!.accounts[account.id] = account;
    // if exists in deletted accounts, remove from there
    String simpleName = AccountUtils.simplifyName(account);
    _vaultData!.deletedAccounts.removeWhere((key, value) =>
        AccountUtils.simplifyName(value) == simpleName &&
        value.fieldUsername.data == account.fieldUsername.data);
    await saveVaultData();
    return true;
  }

  Account? findAccountById(int accountId) {
    return _vaultData!.accounts[accountId];
  }

  AccountGroup? findGroupById(int groupId) {
    return _vaultData!.groups[groupId];
  }

  void deleteAccount(Account account) {
    account.status = LifeStatus.deleted;
    _vaultData!.accounts.remove(account.id);
    _vaultData!.deletedAccounts[account.id] = account;
    saveVaultData();
  }

  void deleteGroup(AccountGroup group) {
    group.status = LifeStatus.deleted;
    _vaultData!.groups.remove(group.id);
    _vaultData!.deletedGroups[group.id] = group;
    saveVaultData();
  }
}

enum SyncResult { accessError, wrongRemoteKey, upToDate }
