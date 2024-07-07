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
  late Directory _rootVaultDir;
  late File _vaultRegisterFile;

  @override
  Future init(String rootPath) async {
    // init and create root path
    _rootVaultDir = Directory(concatPath(rootPath, VAULTS_DIR_NAME));
    await _rootVaultDir.create(recursive: true);

    // init and create register poth
    _vaultRegisterFile =
        File(concatPath(_rootVaultDir.path, VAULT_REGISTER_FILE_NAME));
    await _updateRegister();
  }

  get rootVaultDir => _rootVaultDir;

  Future<List<VaultRegister>> _updateRegister() async {
    List<VaultRegister> vaultRegisters = [];

    bool update = false;
    if (_vaultRegisterFile.existsSync()) {
      RepositoryRegister register = RepositoryRegister.fromJson(
          jsonDecode(_vaultRegisterFile.readAsStringSync()));
      // get registered vault path list
      vaultRegisters = register.registers;
      final registerVaultPathList =
          vaultRegisters.map<String>((e) => e.path).toList();
      // get real file path list
      final fileVaultPathList = _rootVaultDir
          .listSync()
          .map<String>((e) =>
              e.absolute.path.substring(_rootVaultDir.absolute.path.length + 1))
          .toList();
      //delete register path from real list
      fileVaultPathList.remove(VAULT_REGISTER_FILE_NAME);

      // get the lists differences
      final difList = [
        ...registerVaultPathList.where((element) =>
            !fileVaultPathList.contains(element) &&
            element.endsWith(VAULT_FILE_EXTENSION)),
        ...fileVaultPathList.where((element) =>
            !registerVaultPathList.contains(element) &&
            element.endsWith(VAULT_FILE_EXTENSION))
      ];
      update = difList.isNotEmpty;
    } else {
      update = true;
    }

    if (update) {
      vaultRegisters = [];
      final list = (await _rootVaultDir.list().toList());
      for (var element in list) {
        if (element is File) {
          if (element.path.endsWith(VAULT_FILE_EXTENSION)) {
            try {
              Vault vault = Vault.fromJson(
                  jsonDecode(element.readAsStringSync())
                      as Map<String, dynamic>);
              vaultRegisters.add(VaultRegister(
                  name: vault.vaultName,
                  modifDate: element.lastModifiedSync(),
                  path: element.absolute.path
                      .substring(_rootVaultDir.absolute.path.length + 1)));
            } catch (e) {}
          }
        }
      }
      String strRegister =
          jsonEncode(RepositoryRegister(registers: vaultRegisters).toJson());
      await _vaultRegisterFile.writeAsString(strRegister);
    }
    return vaultRegisters;
  }

  Future<File?> tryToImportVaultFromFile(File file)async{
    try {
      final localFile= await file.copy(concatPath(_rootVaultDir.path, file.path.split('/').last));
      await _updateRegister();
      return localFile;
    } catch (e) {
      return null;
    }
  }

  /// returns (<the new file>, <was created>)
  Future<(File?, bool)> _getVaultFile(String vaultName, bool create) async {
    VaultRegister vaultRegister;
    try {
      vaultRegister = (await listVaults())
          .firstWhere((element) => element.name == vaultName);
      return (File(concatPath(_rootVaultDir.path, vaultRegister.path)), false);
    } catch (e) {
      if (create) {
        vaultRegister = VaultRegister(
            name: vaultName,
            modifDate: DateTime.now(),
            path: '$vaultName$VAULT_FILE_EXTENSION');
        return (File(concatPath(_rootVaultDir.path, vaultRegister.path)), true);
      } else {
        return (null, false);
      }
    }
  }

  @override
  Future<Vault?> readVault(
      EncryptAlgorithm algorithm, String key, String vaultName) async {
    String? text =
        await (await _getVaultFile(vaultName, false)).$1?.readAsString();
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
    final fileResult = (await _getVaultFile(vaultName, true));
    fileResult.$1!.writeAsString(strUserData);
    if (fileResult.$2) {
      _updateRegister();
    }
  }

  @override
  Future<bool> deleteVault(String vaultName) async {
    VaultRegister vaultRegister;
    try {
      vaultRegister = (await listVaults())
          .firstWhere((element) => element.name == vaultName);
      await File(concatPath(_rootVaultDir.path, vaultRegister.path)).delete();
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

  @override
  Future<Vault> decryptVault(
      EncryptAlgorithm algorithm, String key, Vault vault) {
    try {
      vault.data = VaultData.fromJson(
          jsonDecode(EncryptUtils.decrypt(algorithm, key, vault.datacrypt)));
    } catch (e) {
      throw const InvalidKeyException();
    }
    return Future.value(vault);
  }
}
