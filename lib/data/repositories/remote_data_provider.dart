import 'package:kyure/data/repositories/data_provider.dart';

abstract class RemoteDataProvider extends DataProvider {

  Future<dynamic> authorize(Map<String, String> values);

  Future<dynamic> getAccessToken(Map<String, String> values);

  Future<dynamic> refreshAccessToken(Map<String, String> values);

  Future<dynamic> createRootDirectory();

  String? get authorizationCode;

  String? get refreshToken;

  set authorizationCode(String? code);

  set refreshToken(String? token);

  String get providerName;
}
