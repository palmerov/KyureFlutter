import 'package:encrypt/encrypt.dart';

enum EncryptAlgorithm {
  AES,
  Salsa20,
  Fernet,
}

class EncryptUtils {
  static String encrypt(
    EncryptAlgorithm algorithm,
    String key,
    String data,
  ) {
    try {
      key = Key.fromUtf8(key).base64;
      final encrypter =
          _getEncrypter(algorithm, Key.fromUtf8(_makeKey(key, 32)));
      final iv = _getIVByAlgorithm(algorithm, key);
      return encrypter.encrypt(data, iv: iv).base64;
    } catch (e) {
      throw EncryptionException(e);
    }
  }

  static String decrypt(
    EncryptAlgorithm algorithm,
    String key,
    String data,
  ) {
    try {
      key = Key.fromUtf8(key).base64;
      final encrypter =
          _getEncrypter(algorithm, Key.fromUtf8(_makeKey(key, 32)));
      final iv = _getIVByAlgorithm(algorithm, key);
      return encrypter.decrypt(Encrypted.fromBase64(data), iv: iv);
    } catch (e) {
      throw EncryptionException(e);
    }
  }

  //a method to make the key: string long as 32 bytes
  static String _makeKey(String key, int lenght) {
    if (key.codeUnits.length < lenght) {
      int diff = lenght - key.codeUnits.length;
      for (int i = 0; i < diff; i++) {
        key += '0';
      }
    }
    if (key.codeUnits.length > lenght) {
      key = String.fromCharCodes(key.codeUnits.sublist(0, lenght));
    }
    return key;
  }

  static IV? _getIVByAlgorithm(EncryptAlgorithm algorithm, String key) {
    switch (algorithm) {
      case EncryptAlgorithm.Fernet:
        return null;
      case EncryptAlgorithm.Salsa20:
        return IV.fromUtf8(_makeKey(key, 8));
      default:
        return IV.fromUtf8(_makeKey(key, 16));
    }
  }

  static Encrypter _getEncrypter(EncryptAlgorithm algorithm, Key key) {
    switch (algorithm) {
      case EncryptAlgorithm.Fernet:
        return Encrypter(Fernet(key));
      case EncryptAlgorithm.Salsa20:
        return Encrypter(Salsa20(key));
      default:
        return Encrypter(AES(key));
    }
  }
}

class EncryptionException implements Exception {
  final dynamic exception;

  EncryptionException([this.exception]);
}

void main(List<String> args) {
  String strkey = 'imn97y7{+]üó}';
  String encrypted = EncryptUtils.encrypt(EncryptAlgorithm.AES, strkey,
      'Simple direct Service Locator that allows to decouple the interface from a concrete implementation and to access the concrete implementation from everywhere in your App"');
  print("encrypted: $encrypted");
  String decrypted =
      EncryptUtils.decrypt(EncryptAlgorithm.AES, strkey, encrypted);
  print("decrypted: $decrypted");
}
