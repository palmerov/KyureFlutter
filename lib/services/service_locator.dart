import 'package:get_it/get_it.dart';
import 'package:kyure/data/repositories/acount_data_repository.dart';
import 'package:kyure/services/kiure_service.dart';

final ServiceLocator serviceLocator = ServiceLocator();

class ServiceLocator {
  late final GetIt _getit;

  ServiceLocator() {
    _getit = GetIt.instance;
  }

  void registerAll() {
    _getit.registerSingleton<AccountDataRepository>(
        AccountDataRepositoryImpl());
    _getit.registerSingleton(KiureService());
  }

  KiureService getKiureService() {
    return _getit.get<KiureService>();
  }

  AccountDataRepository getAccountDataRepository() {
    return _getit.get<AccountDataRepository>();
  }
}
