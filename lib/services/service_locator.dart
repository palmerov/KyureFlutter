import 'package:get_it/get_it.dart';
import 'package:kyure/data/repositories/data_provider.dart';
import 'package:kyure/data/repositories/local_data_provider.dart';
import 'package:kyure/services/kiure_service.dart';
import 'package:kyure/services/vault_service.dart';

final ServiceLocator serviceLocator = ServiceLocator();

class ServiceLocator {
  late final GetIt _getit;

  ServiceLocator() {
    _getit = GetIt.instance;
  }

  void registerAll() {
    _getit.registerSingleton<LocalDataProvider>(LocalDataProvider());
    _getit.registerSingleton(VaultService());
    _getit.registerSingleton(KiureService());
  }

  void registerRemoteDataProvider<T extends DataProvider>(T instance) {
    _getit.registerSingleton<T>(instance);
  }


  KiureService getKiureService() {
    return _getit.get<KiureService>();
  }

  LocalDataProvider getLocalDataProvider() {
    return _getit.get<LocalDataProvider>();
  }

  VaultService getVaultService() {
    return _getit.get<VaultService>();
  }

  T getRemoteDataProvider<T extends DataProvider>() {
    return _getit.get<T>();
  }
}
