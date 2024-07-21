import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kyure/data/repositories/remote_data_provider.dart';
import 'package:kyure/services/kiure_service.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:kyure/services/vault_service.dart';
import '../../../data/models/cloud_settings.dart';

class CloudSettingsCubit extends Cubit<CloudSettingsState> {
  RemoteDataProvider get remoteDataProvider =>
      serviceLocator.getRemoteDataProvider(RemoteProvider.Dropbox);

  KiureService get kiureService => serviceLocator.getKiureService();

  CloudSettingsCubit() : super(CloudSettingsState.initial()) {
    if (kiureService.remoteSettings != null) {
      emit(CloudSettingsState(settings: kiureService.remoteSettings));
    }
  }

  void setupDropBoxToken(String authorizationCode) async {
    emit(const CloudSettingsState(
        settings: null, waitingForToken: false, loading: true));
    try {
      remoteDataProvider.authorizationCode = authorizationCode;
      await remoteDataProvider.getAccessToken({});
      final response = await remoteDataProvider.createRootDirectory();
      kiureService.saveRemoteSettings();
      emit(CloudSettingsState(
          settings: kiureService.remoteSettings,
          waitingForToken: false,
          loading: false));
    } catch (ex) {
      emit(CloudSettingsState(
          settings: null,
          waitingForToken: false,
          loading: false,
          error: ex.toString()));
    }
  }

  bool isAuthorized() {
    return serviceLocator.getDropboxService().isAuthorized();
  }

  void startWithDropBox() {
    emit(CloudSettingsState(settings: null, waitingForToken: true));
    remoteDataProvider.authorize({});
  }
}

class CloudSettingsState extends Equatable {
  const CloudSettingsState(
      {required this.settings,
      this.waitingForToken = false,
      this.loading = false,
      this.error});

  final RemoteSettings? settings;
  final bool waitingForToken;
  final bool loading;
  final String? error;

  factory CloudSettingsState.initial() {
    return CloudSettingsState(settings: null);
  }

  @override
  List<Object?> get props => [
        settings?.provider.name ?? '',
        settings?.authorizationCode ?? '',
        waitingForToken,
        loading,
        error ?? ''
      ];
}
