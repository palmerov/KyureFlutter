import 'package:kyure/data/models/vault.dart';
import 'package:kyure/data/models/vault_register.dart';
import 'package:kyure/data/repositories/data_provider.dart';
import 'package:kyure/data/utils/encrypt_utils.dart';

class DropBoxDataProvider implements DataProvider{

  @override
  Future<void> init(String rootPath) {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  Future<List<VaultRegister>> listVaults() {
    // TODO: implement listVaults
    throw UnimplementedError();
  }

  @override
  Future<Vault?> readVault(EncryptAlgorithm algorithm, String key, String vaultName) {
    // TODO: implement readVault
    throw UnimplementedError();
  }

  @override
  Future<void> writeVault(EncryptAlgorithm algorithm, String key, String vaultName, Vault vault) {
    // TODO: implement writeVault
    throw UnimplementedError();
  }

  @override
  Future<void> deleteVault(String vaultName) {
    // TODO: implement deleteVault
    throw UnimplementedError();
  }
  
}

class RemoteInitData{
  
}