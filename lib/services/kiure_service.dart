import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:kyure/config/values.dart';
import 'package:kyure/data/models/cloud_settings.dart';
import 'package:kyure/data/models/vault_data.dart';
import 'package:kyure/data/utils/file_utils.dart';
import 'package:kyure/main.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:kyure/services/vault_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KiureService {
  late SharedPreferences _prefs;
  late VaultService _vaultService;
  RemoteSettings? remoteSettings;
  bool initialized = false;
  Map<String, dynamic> _recentAccountIds = {};
  List<Account> _vaultRecentAccounts = [];
  String? _vaultName;
  int _recentLenght = 4;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> init() async {
    if (initialized) return;
    initialized = true;

    // prefs
    _vaultName = _prefs.getString('vaultName');

    // services
    String rootPath = (await getLocalInternalRootDir()).path;
    _vaultService = serviceLocator.getVaultService();
    await _vaultService.init(rootPath, VAULTS_DIR_NAME);

    // recent accounts
    _recentAccountIds = jsonDecode(_prefs.getString('recent_accounts') ?? '{}');
    _recentLenght = _prefs.getInt('recent_legnth') ?? 4;
  }

  set vaultName(String? name) {
    _vaultName = name;
    if (name == null) {
      _prefs.remove('vaultName');
    } else {
      _prefs.setString('vaultName', name);
    }
  }

  void loadRemoteSettings() {
    String? provider = _prefs.getString('remote_provider');
    if (provider == null) return;
    RemoteProvider? remoteProvider = RemoteProvider.fromName(provider);
    if (remoteProvider == null) return;
    try {
      remoteSettings = RemoteSettings(
          provider: remoteProvider,
          authorizationCode:
              _prefs.getString('remote_authorization_code') ?? '',
          refreshToken: _prefs.getString('refresh_token') ?? '');
      _vaultService.remoteDataProvider =
          serviceLocator.getRemoteDataProvider(remoteProvider);
      _vaultService.remoteDataProvider!.authorizationCode =
          remoteSettings!.authorizationCode;
      _vaultService.remoteDataProvider!.refreshToken =
          remoteSettings!.refreshToken;
      if (remoteSettings!.refreshToken.isNotEmpty) {
        try {
          _vaultService.remoteDataProvider!.refreshAccessToken({});
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }
    } catch (ex) {
      if (kDebugMode) {
        print(ex.toString());
      }
    }
  }

  void saveRemoteSettings() {
    if (_vaultService.remoteDataProvider!.authorizationCode != null) {
      remoteSettings = RemoteSettings(
          provider: RemoteProvider.fromName(
                  _vaultService.remoteDataProvider!.providerName) ??
              RemoteProvider.Dropbox,
          authorizationCode:
              _vaultService.remoteDataProvider!.authorizationCode!,
          refreshToken: _vaultService.remoteDataProvider!.refreshToken!);
      _prefs.setString('remote_provider', remoteSettings!.provider.name);
      _prefs.setString('refresh_token', remoteSettings!.refreshToken);
      _prefs.setString(
          'remote_authorization_code', remoteSettings!.authorizationCode);
    }
  }

  set brigtnessLight(bool light) => _prefs.setBool('light', light);

  bool get brigtnessLight => _prefs.getBool('light') ?? true;

  String? get vaultName => _vaultName;

  Future<String> exportFile() async {
    Directory dir = Platform.isAndroid
        ? (await getExternalStorageDirectory())!
        : await getApplicationDocumentsDirectory();
    String savePath = '${dir.path}exp_accounts_${DateTime.now()}.kiure';
    await _vaultService.getVaultFile().copy(savePath);
    return savePath;
  }

  List<Account> _getRecentAcounts() {
    if (vaultName == null) return [];
    String accounts = _recentAccountIds[vaultName!] ?? '';
    if (accounts.isNotEmpty) {
      final accIdList = accounts.split(',');
      if (accIdList.isNotEmpty) {
        try {
          List<Account> accounts = [];
          for (var accId in accIdList) {
            final account = _vaultService.findAccountById(int.parse(accId));
            if (account != null) {
              accounts.add(account);
            }
          }
          return accounts;
        } catch (exception) {}
      }
    }
    return [];
  }

  List<Account> get vaultRecentAccounts => _vaultRecentAccounts;

  addToRecents(Account account) async {
    if (_recentAccountIds.containsKey(vaultName!)) {
      int index = _vaultRecentAccounts
          .indexWhere((element) => element.id == account.id);
      if (index < 0) {
        if (vaultRecentAccounts.length >= _recentLenght) {
          _vaultRecentAccounts =
              _vaultRecentAccounts.sublist(0, _recentLenght - 1);
        }
        _vaultRecentAccounts.insert(0, account);
      } else {
        if (index > 0) {
          _vaultRecentAccounts.removeAt(index);
          _vaultRecentAccounts.insert(0, account);
        } else {
          return;
        }
      }
      _recentAccountIds[vaultName!] = _vaultRecentAccounts
          .map((e) => e.id.toString())
          .reduce((value, element) => '$value,$element');
    } else {
      _vaultRecentAccounts.add(account);
      _recentAccountIds[vaultName!] = '${account.id}';
    }
    await _prefs.setString('recent_accounts', jsonEncode(_recentAccountIds));
    appBloc.restartSystemTry();
  }
}
