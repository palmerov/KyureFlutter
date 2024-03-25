import 'package:dio/dio.dart';
import 'package:kyure/config/dropbox_values.dart';
import 'package:kyure/data/models/vault.dart';
import 'package:kyure/data/models/vault_register.dart';
import 'package:kyure/data/repositories/remote_data_provider.dart';
import 'package:kyure/data/utils/encrypt_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DropboxDataProvider implements RemoteDataProvider {
  late final Dio dio;
  String? _accessToken, _refresh_token;
  int _expirationTimeInSeconds = 0;

  String? authorizationCode = '';

  @override
  Future<void> init(String rootPath) async {
    dio = Dio(BaseOptions(
      baseUrl: DropboxValues.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    ));
  }

  @override
  Future authorize(Map<String, String> values) async {
    String url = DropboxValues.authorizationUrl;
    await launchUrlString(url);
  }

  @override
  Future getToken(Map<String, String> values) async {
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
    _startRefreshTokenTimer();
  }

  Future _refreshToken() async {
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
    _startRefreshTokenTimer();
  }

  _startRefreshTokenTimer() {
    Future.delayed(Duration(seconds: _expirationTimeInSeconds), () async {
      await _refreshToken();
    });
  }

  @override
  Future<Vault> decryptVault(
      EncryptAlgorithm algorithm, String key, Vault vault) {
    // TODO: implement decryptVault
    throw UnimplementedError();
  }

  @override
  Future<void> deleteVault(String vaultName) {
    // TODO: implement deleteVault
    throw UnimplementedError();
  }

  @override
  Future<List<VaultRegister>> listVaults() {
    // TODO: implement listVaults
    throw UnimplementedError();
  }

  @override
  Future<Vault?> readVault(
      EncryptAlgorithm algorithm, String key, String vaultName) {
    // TODO: implement readVault
    throw UnimplementedError();
  }

  @override
  Future<void> writeVault(
      EncryptAlgorithm algorithm, String key, String vaultName, Vault vault) {
    // TODO: implement writeVault
    throw UnimplementedError();
  }
}
