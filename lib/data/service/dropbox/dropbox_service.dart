import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:kyure/config/http_content_types.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../config/dropbox_values.dart';

class DropboxService {
  late final Dio _dio;
  String? _accessToken, _refresh_token;
  int _expirationTimeInSeconds = 0;
  String? authorizationCode = '';
  Completer? _authCompleter;

  init() {
    // init dio
    _dio = Dio(BaseOptions(
      baseUrl: DropboxValues.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ));
  }

  startAuthorization() async {
    String url = DropboxValues.authorizationUrl;
    await launchUrlString(url);
  }

  getToken() async {
    _authCompleter = Completer();
    if (authorizationCode == null) {
      throw Exception('Authorization code is null');
    }
    final apiResponse = await _dio.post(
      DropboxValues.oauthTokenUrl,
      options: Options(contentType: HttpContentType.xWwwFormUrlencoded.value),
      data: {
        'code': authorizationCode,
        'grant_type': 'authorization_code',
        'token_access_type': 'offline',
        'client_id': DropboxValues.apkKey,
        'client_secret': DropboxValues.appSecret,
      },
    );
    if (apiResponse.data == null) {
      throw Exception('Null response exception');
    }
    _accessToken = apiResponse.data['access_token'];
    _expirationTimeInSeconds = apiResponse.data['expires_in'];
    _refresh_token = apiResponse.data['refresh_token'];

    _dio.options = _dio.options.copyWith(headers: {
      'Authorization': 'Bearer $_accessToken',
    });
    _authCompleter!.complete();
    _startRefreshTokenTimer();
  }

  Future _refreshToken() async {
    _authCompleter = Completer();
    final apiResponse = await _dio.post(DropboxValues.oauthTokenUrl,
        options: Options(contentType: HttpContentType.xWwwFormUrlencoded.value),
        data: {
          'refresh_token': _refresh_token,
          'grant_type': 'refresh_token',
          'client_id': DropboxValues.apkKey,
          'client_secret': DropboxValues.appSecret,
        });
    if (apiResponse.data == null) {
      throw Exception('Null response exception');
    }
    _dio.options = _dio.options.copyWith(headers: {
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

  Future<Response<dynamic>?> createDirectory(String path) async {
    await _authOperations();
    try {
      final response = await _dio.post(DropboxValues.createFolderUrl,
          options: Options(contentType: HttpContentType.json.value),
          data: {"autorename": false, "path": path});
      return response;
    } on Exception catch (e) {
      log('Exception creating directory in dropbox cloud', error: e.toString());
      return null;
    }
  }

  Future<Response<dynamic>?> deleteFile(String path) async {
    await _authOperations();
    try {
      final response = await _dio.post(DropboxValues.deleteFileUrl,
          options: Options(contentType: HttpContentType.json.value),
          data: {'path': path});
      return response;
    } on Exception catch (e) {
      log('Exception deleting file in dropbox cloud', error: e.toString());
      return null;
    }
  }

  Future<Response<dynamic>?> downloadFileUrl(
      String remotePath, String localPath) async {
    await _authOperations();
    try {
      final response =
          await _dio.download(DropboxValues.downloadFileUrl, localPath,
              options: Options(headers: {
                'Dropbox-API-Arg': '{"path": "$remotePath"}',
              }));
      return response;
    } on Exception catch (e) {
      log('Exception downloading file from dropbox cloud', error: e.toString());
      return null;
    }
  }

  Future<Response<dynamic>?> uploadFile(String localPath, String remotePath,
      [bool replace = true]) async {
    await _authOperations();
    try {
      final response = await _dio.put(DropboxValues.uploadFileUrl,
          data: await MultipartFile.fromFile(localPath),
          options: Options(headers: {
            'Dropbox-API-Arg':
                '{autorename: false,mode: ${replace ? 'add,' : 'overwrite,'}mute: false,path: "$remotePath",strict_conflict: false}'
          }, contentType: 'application/octet-stream'));
      return response;
    } on Exception catch (e) {
      log('Exception deleting file in dropbox cloud', error: e.toString());
      return null;
    }
  }
}
