import 'package:get_it/get_it.dart';
import 'package:kyure/data/repositories/data_provider.dart';
import 'package:kyure/data/repositories/dropbox/dropbox_data_provider.dart';
import 'package:kyure/data/repositories/local/local_data_provider.dart';
import 'package:kyure/data/repositories/remote_data_provider.dart';
import 'package:kyure/data/service/dropbox/dropbox_service.dart';
import 'package:kyure/services/kiure_service.dart';
import 'package:kyure/services/vault_service.dart';

final ServiceLocator serviceLocator = ServiceLocator();

enum RemoteProviders { Dropbox, GoogleDrive, OneDrive}

class ServiceLocator {
  late final GetIt _getit;

  ServiceLocator() {
    _getit = GetIt.instance;
  }

  void registerAll() {
    _getit.registerSingleton<LocalDataProvider>(LocalDataProvider());
    _getit.registerLazySingleton(() => DropboxService()..init());
    _getit.registerLazySingleton<DropboxDataProvider>(() => DropboxDataProvider()..init('/Kiure/vaults'));
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

  RemoteDataProvider getRemoteDataProvider(RemoteProviders provider) {
    switch (provider) {
      case RemoteProviders.Dropbox:
        return _getit.get<DropboxDataProvider>();
      default:
        throw Exception('Provider not found');
    }
  }

  DropboxService getDropboxService() {
    return _getit.get<DropboxService>();
  }
}
