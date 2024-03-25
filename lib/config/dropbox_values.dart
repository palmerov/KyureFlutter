class DropboxValues {
  static const String apkKey = 'ygzf4h7jnlhokvm';
  static const String appSecret = '88wpj5yzf8x3o0v';
  static const String redirectUri = 'kiure://callback';
  static const String _authorizationUrl =
      'https://www.dropbox.com/oauth2/authorize';

  // url
  static const String baseUrl = 'https://api.dropboxapi.com/';
  static const String _oauthTokenUrl = 'oauth2/token';

  static get authorizationUrl =>
      '$_authorizationUrl?client_id=$apkKey&response_type=code';

  static get oauthTokenUrl => '$baseUrl$_oauthTokenUrl';
}
