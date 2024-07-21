import '../../services/service_locator.dart';

class RemoteSettings {
  RemoteSettings(
      {required this.provider,
      required this.authorizationCode,
      required this.refreshToken});

  final RemoteProvider provider;
  final String authorizationCode;
  final String refreshToken;
}
