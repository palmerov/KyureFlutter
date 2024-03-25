import 'package:kyure/data/repositories/data_provider.dart';

abstract class RemoteDataProvider extends DataProvider {

  Future<dynamic> authorize(Map<String, String> values);

  Future<dynamic> getToken(Map<String, String> values);
}
