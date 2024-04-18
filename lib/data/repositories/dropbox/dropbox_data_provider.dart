import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:kyure/config/dropbox_values.dart';
import 'package:kyure/data/models/vault.dart';
import 'package:kyure/data/models/vault_register.dart';
import 'package:kyure/data/repositories/remote_data_provider.dart';
import 'package:kyure/data/utils/encrypt_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../config/values.dart';
import '../../utils/file_utils.dart';

class DropboxDataProvider implements RemoteDataProvider {
  late final Dio dio;
  String? _accessToken, _refresh_token;
  int _expirationTimeInSeconds = 0;
  String? authorizationCode = '';
  late String _rootVaultDir, _vaultRegisterFilePath;
  Completer? _authCompleter;

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
    // init root and register paths
    _rootVaultDir = rootPath;
    _vaultRegisterFilePath =
        concatPath(_rootVaultDir, VAULT_REGISTER_FILE_NAME);
  }

  @override
  Future authorize(Map<String, String> values) async {
    String url = DropboxValues.authorizationUrl;
    await launchUrlString(url);
  }

  @override
  Future getToken(Map<String, String> values) async {
    _authCompleter = Completer();
    if (authorizationCode == null) {
      throw Exception('Authorization code is null');
    }
    final apiResponse = await dio.post(DropboxValues.oauthTokenUrl, data: {
      'code': authorizationCode,
      'grant_type': 'authorization_code',
      'token_access_type': 'offline',
      'client_id': DropboxValues.apkKey,
      'client_secret': DropboxValues.appSecret,
    });
    if (apiResponse.data == null) {
      throw Exception('Null response exception');
    }
    _accessToken = apiResponse.data['access_token'];
    _expirationTimeInSeconds = apiResponse.data['expires_in'];
    _refresh_token = apiResponse.data['refresh_token'];

    dio.options = dio.options.copyWith(headers: {
      'Authorization': 'Bearer $_accessToken',
    });
    _authCompleter!.complete();
    _startRefreshTokenTimer();
  }

  Future _refreshToken() async {
    _authCompleter = Completer();
    final apiResponse = await dio.post(DropboxValues.oauthTokenUrl, data: {
      'refresh_token': _refresh_token,
      'grant_type': 'refresh_token',
      'client_id': DropboxValues.apkKey,
      'client_secret': DropboxValues.appSecret,
    });
    if (apiResponse.data == null) {
      throw Exception('Null response exception');
    }
    dio.options = dio.options.copyWith(headers: {
      'Authorization': 'Bearer $_accessToken',
    });
    _accessToken = apiResponse.data['access_token'];
    _expirationTimeInSeconds = apiResponse.data['expires_in'];
    _authCompleter!.complete();
    _startRefreshTokenTimer();
  }

  _startRefreshTokenTimer() {
    Future.delayed(
        Duration(
            seconds: (_expirationTimeInSeconds > 1)
                ? (_expirationTimeInSeconds - 1)
                : 0), () async {
      await _refreshToken();
    });
  }

  _authOperations() async {
    if (!_authCompleter!.isCompleted) {
      await _authCompleter!.future;
    }
  }

  Future<bool> createRootDirectory() async {
    await _authOperations();
    try {
      final response = await dio.post(DropboxValues.createFolderUrl,
          data: {"autorename": false, "path": '/kiure/$VAULTS_DIR_NAME'});
      if (response.data.contains('metadata')) {
        return true;
      }
      return false;
    } on Exception catch (e) {
      log('Exception creating RootDirectory in dropbox cloud',
          error: e.toString());
      return false;
    }
  }

  @override
  Future<Vault> decryptVault(
      EncryptAlgorithm algorithm, String key, Vault vault) async {
    await _authOperations();
    // TODO: implement decryptVault
    throw UnimplementedError();
  }

  @override
  Future<void> deleteVault(String vaultName)async {
    await _authOperations();

    // TODO: implement deleteVault
    throw UnimplementedError();
  }

  @override
  Future<List<VaultRegister>> listVaults() async{
    await _authOperations();

    // TODO: implement listVaults
    throw UnimplementedError();
  }

  @override
  Future<Vault?> readVault(
      EncryptAlgorithm algorithm, String key, String vaultName)async {
    await _authOperations();

    // TODO: implement readVault
    throw UnimplementedError();
  }

  @override
  Future<void> writeVault(
      EncryptAlgorithm algorithm, String key, String vaultName, Vault vault)async {
    await _authOperations();

    // TODO: implement writeVault
    throw UnimplementedError();
  }
}
