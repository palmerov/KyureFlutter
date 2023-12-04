import 'dart:convert';
import 'dart:io';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/data/models/vault.dart';
import 'package:kyure/data/utils/encrypt_utils.dart';

class AccountDataRepositoryImpl implements AccountDataRepository {
  late String _rootPath;
  late Directory _rootDir;

  @override
  Future init(String rootPath) async {
    _rootPath = rootPath;
    _rootDir = Directory(rootPath);
  }

  @override
  File getVaultFile(String vaultName) {
    if (!vaultName.endsWith('.kiure')) {
      vaultName = '$vaultName.kiure';
    }
    return File('$_rootPath/$vaultName');
  }

  @override
  Future<Vault> readUserData(
      EncryptAlgorithm algorithm, String key, String vaultName) async {
    String text = await getVaultFile(vaultName).readAsString();
    Map<String, dynamic> json = jsonDecode(text);
    Vault userData = Vault.fromJson(json);
    userData.accountsData = VaultData.fromJson(
        jsonDecode(EncryptUtils.decrypt(algorithm, key, userData.datacrypt)));
    return userData;
  }

  @override
  Future<void> writeUserData(EncryptAlgorithm algorithm, String key,
      String vaultName, Vault userData) async {
    userData.datacrypt = EncryptUtils.encrypt(
        algorithm, key, jsonEncode(userData.accountsData!.toJson()));
    userData.version++;
    String strUserData = jsonEncode(userData);
    await getVaultFile(vaultName).writeAsString(strUserData);
  }

  @override
  Future<List<String>> getVaultNames() async {
    return await _rootDir.list().map((e) {
      String name = e.path.split('/').last;
      if (name.endsWith('.kiure')) {
        return name.substring(0, name.length - 6);
      }
      return name;
    }).toList();
  }
}

abstract class AccountDataRepository {
  Future<Vault> readUserData(
      EncryptAlgorithm algorithm, String key, String vaultName);
  Future<void> writeUserData(EncryptAlgorithm algorithm, String key,
      String vaultName, Vault userData);
  Future<List<String>> getVaultNames();
  File getVaultFile(String vaultName);
  Future init(String rootPath);
}