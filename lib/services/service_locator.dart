import 'package:get_it/get_it.dart';
import 'package:kyure/data/models/accounts_data.dart';
import 'package:kyure/data/repositories/acount_data_repository.dart';
import 'package:kyure/services/user_data_service.dart';

final ServiceLocator serviceLocator = ServiceLocator();

class ServiceLocator {
  late final GetIt _getit;

  ServiceLocator() {
    _getit = GetIt.instance;
  }

  void registerAll() {
    _getit.registerSingleton<AccountDataRepository>(
        AccountDataRepositoryMocked());
    _getit.registerSingleton(UserDataService());
  }

  UserDataService getUserDataService() {
    return _getit.get<UserDataService>();
  }

  AccountDataRepository getAccountDataRepository() {
    return _getit.get<AccountDataRepository>();
  }
}
