import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:kyure/config/values.dart';
import 'package:kyure/data/models/vault.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/data/models/vault_register.dart';
import 'package:kyure/data/repositories/data_provider.dart';
import 'package:kyure/data/repositories/local/local_data_provider.dart';
import 'package:kyure/data/repositories/remote_data_provider.dart';
import 'package:kyure/data/utils/account_utils.dart';
import 'package:kyure/data/utils/encrypt_utils.dart';
import 'package:kyure/data/utils/file_utils.dart';
import 'package:kyure/data/utils/group_utils.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:kyure/services/version/vault_version_system_service.dart';

import '../data/models/sync_result.dart';

class VaultService {
  late VaultVersionSystemService vaultVersionSystemService;
  late LocalDataProvider localDataProvider;
  RemoteDataProvider? remoteDataProvider;
  List<VaultRegister> _localVaultRegisters = [];

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

  init(String localPath, String remotePath) async {
    vaultVersionSystemService = VaultVersionSystemService();
    // local
    localDataProvider = serviceLocator.getLocalDataProvider();
    await localDataProvider.init({'localRootPath': localPath});
    _localVaultRegisters = await localDataProvider.listVaults();
    if (_localVaultRegisters.isNotEmpty) {
      _vaultName = _localVaultRegisters[0].name;
    }

    try {
      remoteDataProvider =
          serviceLocator.getRemoteDataProvider(RemoteProvider.Dropbox);
      if (remoteDataProvider != null) {
        await remoteDataProvider!
            .init({'localRootPath': localPath, 'remoteRootPath': remotePath});
      }
    } catch (e) {}
  }

  bool existVaultInLocal(String vaultName) {
    return _localVaultRegisters
        .where((element) => element.name == vaultName)
        .isNotEmpty;
  }

  Future<File?> tryToImportVaultFile(File file) async {
    final localFile = await localDataProvider.tryToImportVaultFromFile(file);
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
        break;
      case SortBy.nameAsc:
        _accounts!.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortBy.modifDateDesc:
        _accounts!.sort((a, b) => a.id.compareTo(b.id));
        break;
      case SortBy.modifDateAsc:
        _accounts!.sort((a, b) => b.id.compareTo(a.id));
        break;
    }
    if (save) saveVaultData(updateDataDate: true);
  }

  File getVaultFile() {
    return File(concatPath(
        localDataProvider.rootVaultDir.data,
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

  Future<void> saveVaultData(
      {bool updateVaultDate = false, bool updateDataDate = false}) async {
    try {
      if (updateVaultDate) _vault!.modifDate = DateTime.now();
      if (updateDataDate) _vaultData!.modifDate = DateTime.now();
      await localDataProvider.writeVault(
          _algorithm!, _key!, _vaultName!, _vault!);
    } catch (exception) {
      print(exception.toString());
      rethrow;
    }
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
    saveVaultData();
  }

  Future<SyncResult> syncWithFile(String? fileVaultKey, File file) async {
    try {
      fileVaultKey ??= _key;
      Vault fileEncryptedVault =
          Vault.fromJson(jsonDecode(file.readAsStringSync()));
      if (fileEncryptedVault.vaultName != _vaultName) {
        return SyncResult.incompatible('Vaults incompatibles');
      }
      try {
        final fileVault = await localDataProvider.decryptVault(
            _algorithm!, fileVaultKey!, fileEncryptedVault);
        final dir = await mergeVault(fileVault, true);
        return SyncResult.success('Sincronizado con éxito', dir);
      } on InvalidKeyException {
        return SyncResult.wrongRemoteKey('Clave externa incorrecta');
      }
    } catch (exception) {
      log(exception.toString());
      return SyncResult.accessError('Error de acceso');
    }
  }

  Future<SyncResult> syncWithRemote(
      {KeyConflictResolver? keyConflictResolver, bool inRetry = false}) async {
    // Start with all keys as the local key
    String writerRemoteKey = _key!;
    String readerRemoteKey = _key!;
    String readerLocalKey = _key!;
    String writerLocalKey = _key!;
    try {
      // If conflict resolver not null, use the remote reader key from it
      readerRemoteKey = keyConflictResolver?.key ?? _key!;
      if (keyConflictResolver?.direction == KeyUpdateDirection.toLocal) {
        // If conflict resolver is set to update the local key, use the remote
        // reader key as local writer key
        writerRemoteKey = readerRemoteKey;
        writerLocalKey = readerRemoteKey;
      } else if (keyConflictResolver?.direction ==
          KeyUpdateDirection.toRemote) {
        // If conflict resolver is set to update the remote key, use the local
        // key as remote writer key
        writerLocalKey = readerLocalKey;
        writerRemoteKey = readerLocalKey;
      }
      await remoteDataProvider!.createRootDirectory();
    } on Exception catch (exception) {
      log(exception.toString());
    }

    if (keyConflictResolver != null &&
        keyConflictResolver.direction == KeyUpdateDirection.toRemote &&
        keyConflictResolver.force) {
      // If conflict resolver is set to update the remote key by force, use the
      // local key as remote writer key and overwrite the remote vault, then
      // return success
      try {
        await remoteDataProvider?.writeVault(
            _algorithm!, writerRemoteKey, _vaultName!, _vault!);
        return SyncResult.success(
            'Sincronizado con éxito', UpdateDirection.toRemote);
      } catch (e) {
        return SyncResult.accessError('Error de acceso');
      }
    }

    Vault? remoteVault;
    try {
      // Read and decode the remote vault
      remoteVault = await remoteDataProvider?.readVault(
          _algorithm!, readerRemoteKey, _vaultName!,
          data: {'inRetry': inRetry});
      if (remoteVault == null) {
        // If the remote vault is null, try to write the local vault to remote
        try {
          await remoteDataProvider?.writeVault(
              _algorithm!, writerRemoteKey, _vaultName!, _vault!);
          return SyncResult.success(
              'Sincronizado con éxito', UpdateDirection.toRemote);
        } catch (e) {
          return SyncResult.accessError('Error de acceso');
        }
      }
    } on AccessibilityException {
      return SyncResult.accessError('Error de acceso');
    } on EncryptionException {
      // If the remote vault is encrypted with a different key, return wrong key
      return SyncResult.wrongRemoteKey('Clave remota incorrecta');
    } on Exception catch (e) {
      return SyncResult.accessError(e.toString());
    }
    String localKeyTemp = _key!;
    try {
      _key = writerLocalKey;
      UpdateDirection updateDirection;
      try {
        // Merge the remote vault with the local vault
        updateDirection = await mergeVault(remoteVault, false);
        await saveVaultData(updateDataDate: keyConflictResolver != null);
        if (updateDirection == UpdateDirection.none &&
            keyConflictResolver?.direction == KeyUpdateDirection.toRemote) {
          updateDirection = UpdateDirection.toRemote;
        }
      } catch (e) {
        _key = localKeyTemp;
        return SyncResult.accessError('Error de acceso');
      }
      if (updateDirection == UpdateDirection.toRemote ||
          updateDirection == UpdateDirection.toBoth ||
          keyConflictResolver?.direction == KeyUpdateDirection.toRemote) {
        try {
          await remoteDataProvider?.writeVault(
              _algorithm!, writerRemoteKey, _vaultName!, _vault!);
        } catch (e) {
          return SyncResult.accessError('Error de acceso');
        }
      }
      return SyncResult.success('Sincronizado con éxito', updateDirection);
    } catch (e) {
      return SyncResult.accessError('Error de acceso');
    }
  }

  Future<UpdateDirection> mergeVault(Vault decryptedVault, bool save) async {
    try {
      final vaultName = decryptedVault.vaultName;
      if (vaultName == _vaultName) {
        UpdateDirection updateDirection;
        VaultData mergedVaultData;
        (mergedVaultData, updateDirection) = await vaultVersionSystemService
            .getMergedData(_vaultData!, decryptedVault.data!);
        if (updateDirection == UpdateDirection.toLocal ||
            updateDirection == UpdateDirection.toBoth) {
          _vaultData = mergedVaultData;
          _vault!.data = mergedVaultData;
          _vault!.modifDate = decryptedVault.modifDate;
          _accounts = _vaultData!.accounts.values.toList();
          _groups = _vaultData!.groups.values.toList();
          if (save) await saveVaultData();
        }
        return updateDirection;
      }
    } catch (exception) {
      rethrow;
    }
    return UpdateDirection.none;
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
    await saveVaultData(updateDataDate: true);
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
    await saveVaultData(updateDataDate: true);
    return true;
  }

  Future updateKey(String key) async {
    _key = key;
    await saveVaultData(updateVaultDate: true);
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
    account.modifDate = DateTime.now();
    account.fieldList?.clear();
    account.fieldUsername.data = '';
    account.fieldUsername.name = '';
    account.fieldPassword.data = '';
    account.fieldPassword.name = '';
    account.name = '';
    account.image = ImageSource(data: '', source: ImageSourceType.asset);
    _vaultData!.accounts.remove(account.id);
    _vaultData!.deletedAccounts[account.id] = account;
    _accounts!
        .removeAt(_accounts!.indexWhere((element) => account.id == element.id));
    if (_vaultData!.deletedAccounts.length >= 20) {
      Account oldestAccount = _vaultData!.deletedAccounts.values.first;
      for (Account account in _vaultData!.deletedAccounts.values) {
        if (account.modifDate.isBefore(oldestAccount.modifDate)) {
          oldestAccount = account;
        }
      }
      _vaultData!.deletedAccounts.remove(oldestAccount.id);
    }
    saveVaultData(updateDataDate: true);
  }

  void deleteGroup(AccountGroup group) {
    group.status = LifeStatus.deleted;
    group.name = '';
    group.iconName = '';
    group.modifDate = DateTime.now();
    _vaultData!.groups.remove(group.id);
    _vaultData!.deletedGroups[group.id] = group;
    _groups!.removeAt(_groups!.indexWhere((element) => group.id == element.id));
    if (_vaultData!.deletedGroups.length >= 20) {
      AccountGroup oldestGroup = _vaultData!.deletedGroups.values.first;
      for (AccountGroup group in _vaultData!.deletedGroups.values) {
        if (group.modifDate.isBefore(oldestGroup.modifDate)) {
          oldestGroup = group;
        }
      }
      _vaultData!.deletedGroups.remove(oldestGroup.id);
    }
    saveVaultData(updateDataDate: true);
  }
}
