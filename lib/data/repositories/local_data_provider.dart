import 'dart:convert';
import 'dart:io';
import 'package:kyure/config/values.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/data/models/vault.dart';
import 'package:kyure/data/models/vault_register.dart';
import 'package:kyure/data/repositories/data_provider.dart';
import 'package:kyure/data/utils/encrypt_utils.dart';
import 'package:kyure/data/utils/file_utils.dart';

class LocalDataProvider implements DataProvider {
  late String _rootPath;
  late Directory _rootDir;
  late File _vaultRegisterFile;

  @override
  Future init(String rootPath) async {
    _rootPath = rootPath;
    _rootDir = Directory(concatPath(rootPath, VAULTS_DIR_NAME));
    if (!await _rootDir.exists()) {
      await _rootDir.create();
    }
    _vaultRegisterFile = File(concatPath(_rootPath, VAULT_REGISTER_FILE_NAME));
  }

  Directory get rootDir => _rootDir;

  void _updateRegister() async {
    List<VaultRegister> vaultRegisters = [];
    _rootDir.list().forEach((element) {
      if (element is File) {
        if (element.path.endsWith(VAULT_FILE_EXTENSION)) {
          Vault vault = Vault.fromJson(
              jsonDecode(element.readAsStringSync()) as Map<String, dynamic>);
          vaultRegisters.add(VaultRegister(
              name: vault.vaultName,
              modifDate: element.lastModifiedSync(),
              path: element.path.substring(_rootDir.path.length + 1)));
        }
      }
    });
    await _vaultRegisterFile.writeAsString(
        jsonEncode(RepositoryRegister(registers: vaultRegisters).toJson()));
  }

  Future<File?> _getVaultFile(String vaultName, bool create) async {
    VaultRegister vaultRegister;
    try {
      vaultRegister = (await listVaults())
          .firstWhere((element) => element.name == vaultName);
      return File(concatPath(_rootDir.path, vaultRegister.path));
    } catch (e) {
      if (create) {
        vaultRegister = VaultRegister(
            name: vaultName,
            modifDate: DateTime.now(),
            path: '$vaultName$VAULT_FILE_EXTENSION');
        _updateRegister();
        return File(concatPath(_rootDir.path, vaultRegister.path));
      } else {
        return null;
      }
    }
  }

  @override
  Future<Vault?> readVault(
      EncryptAlgorithm algorithm, String key, String vaultName) async {
    String? text =
        await (await _getVaultFile(vaultName, false))?.readAsString();
    if (text != null) {
      Map<String, dynamic> json = jsonDecode(text);
      Vault userData = Vault.fromJson(json);
      userData.data = VaultData.fromJson(
          jsonDecode(EncryptUtils.decrypt(algorithm, key, userData.datacrypt)));
      return userData;
    }
    return null;
  }

  @override
  Future<void> writeVault(EncryptAlgorithm algorithm, String key,
      String vaultName, Vault vault) async {
    vault.datacrypt =
        EncryptUtils.encrypt(algorithm, key, jsonEncode(vault.data!.toJson()));
    String strUserData = jsonEncode(vault);
    (await _getVaultFile(vaultName, true))!.writeAsString(strUserData);
  }

  @override
  Future<bool> deleteVault(String vaultName) async {
    VaultRegister vaultRegister;
    try {
      vaultRegister = (await listVaults())
          .firstWhere((element) => element.name == vaultName);
      await File(concatPath(_rootDir.path, vaultRegister.path)).delete();
      _updateRegister();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<VaultRegister>> listVaults() async {
    return await _vaultRegisterFile.exists()
        ? RepositoryRegister.fromJson(
                jsonDecode(await _vaultRegisterFile.readAsString()))
            .registers
        : [];
  }
}
