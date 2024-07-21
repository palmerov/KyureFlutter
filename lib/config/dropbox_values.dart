class DropboxValues {
  static const String apkKey = 'ygzf4h7jnlhokvm';
  static const String appSecret = '88wpj5yzf8x3o0v';
  static const String redirectUri = 'kiure://callback';
  static const String _authorizationUrl =
      'https://www.dropbox.com/oauth2/authorize';

  // url
  static const String baseUrl = 'https://api.dropboxapi.com/';
  static const String _oauthTokenUrl = 'oauth2/token';
  static const String _createFolderUrl = '2/files/create_folder_v2';
  static const String _listFilesUrl = '2/file_requests/list_v2';
  static const String _downloadFileUrl = '2/files/download';
  static const String _uploadFileUrl = '2/files/upload';
  static const String _createFileUrl = '2/file_requests/create';
  static const String _deleteFileUrl = '2/file_requests/delete';
  static const String _getFileUrl = '2/file_requests/get';

  static get authorizationUrl =>
      '$_authorizationUrl?client_id=$apkKey&response_type=code&token_access_type=offline';

  static get oauthTokenUrl => '$baseUrl$_oauthTokenUrl';

  static get createFolderUrl => '$baseUrl$_createFolderUrl';

  static get listFilesUrl => '$baseUrl$_listFilesUrl';

  static get createFileUrl => '$baseUrl$_createFileUrl';

  static get deleteFileUrl => '$baseUrl$_deleteFileUrl';

  static get getFileUrl => '$baseUrl$_getFileUrl';

  static get downloadFileUrl => '$baseUrl$_downloadFileUrl';

  static get uploadFileUrl => '$baseUrl$_uploadFileUrl';
}
