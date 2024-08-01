// the abstract for LocalDataProvider
import 'package:kyure/data/models/vault.dart';
import 'package:kyure/data/models/vault_register.dart';
import 'package:kyure/data/utils/encrypt_utils.dart';

abstract class DataProvider {
  Future<void> init(Map<String, dynamic> values);

  Future<bool> writeVault(
      EncryptAlgorithm algorithm, String key, String vaultName, Vault vault);

  Future<Vault?> readVault(
      EncryptAlgorithm algorithm, String key, String vaultName,
      {Map<String, dynamic>? data});

  Future<Vault> decryptVault(
      EncryptAlgorithm algorithm, String key, Vault vault);

  Future<bool> deleteVault(String vaultName);

  Future<List<VaultRegister>> listVaults();
}

class InvalidKeyException implements Exception {
  const InvalidKeyException() : super();
}

class AccessibilityException implements Exception {
  const AccessibilityException() : super();
}
