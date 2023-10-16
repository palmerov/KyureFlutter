import 'package:get_it/get_it.dart';
import 'package:kyure/data/services/user_data_service.dart';

final ServiceLocator serviceLocator = ServiceLocator();

class ServiceLocator {
  late final GetIt _getit;

  ServiceLocator() {
    _getit = GetIt.instance;
  }

  void registerAll() {
    _getit.registerSingleton(UserDataService());
  }

  UserDataService getUserDataService() {
    return _getit.get<UserDataService>();
  }
}
