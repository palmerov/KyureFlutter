import 'dart:async';
import 'dart:convert';
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
  late String _rootVaultDir, _vaultRegisterFilePath;
  late final DropboxApiService _dropboxService;

  @override
  Future<void> init(String rootPath) async {
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
    _rootVaultDir = rootPath;
    _vaultRegisterFilePath =
        concatPath(_rootVaultDir, VAULT_REGISTER_FILE_NAME);
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
    return await _dropboxService.createDirectory(_rootVaultDir);
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
  Future<void> deleteVault(String vaultName) async {
    await _dropboxService.deleteFile(concatPath(_rootVaultDir, vaultName));
  }

  @override
  Future<List<VaultRegister>> listVaults() async {
    return [];
  }

  @override
  Future<Vault?> readVault(
      EncryptAlgorithm algorithm, String key, String vaultName) async {
    // TODO: implement readVault
    throw UnimplementedError();
  }

  @override
  Future<void> writeVault(EncryptAlgorithm algorithm, String key,
      String vaultName, Vault vault) async {
    // TODO: implement writeVault
    throw UnimplementedError();
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
