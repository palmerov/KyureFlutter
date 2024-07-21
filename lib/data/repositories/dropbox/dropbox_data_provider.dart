import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kyure/config/dropbox_values.dart';
import 'package:kyure/data/models/vault.dart';
import 'package:kyure/data/models/vault_register.dart';
import 'package:kyure/data/repositories/remote_data_provider.dart';
import 'package:kyure/data/service/dropbox/dropbox_api_service.dart';
import 'package:kyure/data/utils/encrypt_utils.dart';
import 'package:kyure/services/service_locator.dart';
import '../../../config/values.dart';
import '../../models/vault_data.dart';
import '../../utils/file_utils.dart';
import '../data_provider.dart';

class DropboxDataProvider implements RemoteDataProvider {
  late final Dio dio;
  late String _remoteVaultPath,
      _remoteRegisterFilePath,
      _localCacheRegisterFilePath;
  late String _localCacheVaultPath;
  late final DropboxApiService _dropboxService;

  @override
  Future<void> init(Map<String, dynamic> values) async {
    // init dio
    dio = Dio(BaseOptions(
      baseUrl: DropboxValues.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    ));
    _dropboxService = serviceLocator.getDropboxService();
    // init root and register paths
    _remoteVaultPath = values['remoteRootPath'];
    _remoteRegisterFilePath =
        concatPath(_remoteVaultPath, VAULT_REGISTER_FILE_NAME, true);
    _localCacheVaultPath = concatPathNames(
        [values['localRootPath'], LOCAL_CACHE_DIR_NAME, VAULTS_DIR_NAME]);
    _localCacheRegisterFilePath =
        concatPathNames([_localCacheVaultPath, VAULT_REGISTER_FILE_NAME]);
  }

  @override
  Future authorize(Map<String, String> values) async {
    return _dropboxService.startAuthorization();
  }

  @override
  Future getAccessToken(Map<String, String> values) async {
    return _dropboxService.getToken();
  }

  @override
  Future<Response<dynamic>?> createRootDirectory() async {
    return await _dropboxService.createDirectory(_remoteVaultPath);
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

  @override
  Future<bool> deleteVault(String vaultName) async {
    return await _dropboxService
            .deleteFile(concatPath(_remoteVaultPath, vaultName)) !=
        null;
  }

  @override
  Future<List<VaultRegister>> listVaults() async {
    final response = await _dropboxService.downloadFileUrl(
        _remoteRegisterFilePath, _localCacheRegisterFilePath);
    if (response == null) {
      return [];
    }
    return RepositoryRegister.fromJson(jsonDecode(
            await (File(_localCacheRegisterFilePath)).readAsString()))
        .registers;
  }

  String _getRemoteVaultFilePath(String vaultName) {
    return concatPath(_remoteVaultPath, vaultName + VAULT_FILE_EXTENSION);
  }

  String _getLocalVaultCacheFilePath(String vaultName) {
    return concatPath(_localCacheVaultPath, vaultName + VAULT_FILE_EXTENSION);
  }

  @override
  Future<File?> downloadRemoteVaultFileToCache(String vaultName) async {
    String remoteFilePath = _getRemoteVaultFilePath(vaultName);
    String localCacheFilePath = _getLocalVaultCacheFilePath(vaultName);
    try {
      await File(localCacheFilePath).delete();
    } catch (ex) {}
    final response = await _dropboxService.downloadFileUrl(
        remoteFilePath, localCacheFilePath);
    if (response != null) {
      return File(localCacheFilePath);
    }
    return null;
  }

  @override
  Future<Vault?> readVault(
      EncryptAlgorithm algorithm, String key, String vaultName) async {
    File? cachedFile = await downloadRemoteVaultFileToCache(vaultName);
    if (cachedFile != null) {
      String? text = await cachedFile.readAsString();
      Map<String, dynamic> json = jsonDecode(text);
      Vault vault = Vault.fromJson(json);
      vault.data = VaultData.fromJson(
          jsonDecode(EncryptUtils.decrypt(algorithm, key, vault.datacrypt)));
      return vault;
    } else {
      return null;
    }
  }

  @override
  Future<bool> writeVault(EncryptAlgorithm algorithm, String key,
      String vaultName, Vault vault) async {
    final response = await _dropboxService.uploadFile(
        (await serviceLocator
                .getLocalDataProvider()
                .getVaultFile(vaultName, false))
            .$1!
            .path,
        _getRemoteVaultFilePath(vaultName));
    return response != null;
  }

  @override
  String? get authorizationCode => _dropboxService.authorizationCode;

  @override
  set authorizationCode(String? code) {
    _dropboxService.authorizationCode = code;
  }

  @override
  String get providerName => RemoteProvider.Dropbox.name;

  @override
  String? get refreshToken => _dropboxService.refresh_token;

  @override
  set refreshToken(String? token) {
    _dropboxService.refresh_token = token;
  }

  @override
  Future refreshAccessToken(Map<String, String> values) {
    return _dropboxService.refreshAccessToken();
  }
}
