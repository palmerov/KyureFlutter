import 'package:bloc/bloc.dart';
import 'package:kyure/data/repositories/remote_data_provider.dart';
import 'package:kyure/services/service_locator.dart';
import '../../../data/models/cloud_settings.dart';

class CloudSettingsCubit extends Cubit<CloudSettingsState> {
  RemoteDataProvider get remoteDataProvider =>
      serviceLocator.getRemoteDataProvider(RemoteProviders.Dropbox);

  CloudSettingsCubit() : super(CloudSettingsState.initial());

  Future<void> loadSettings() async {}

  Future<void> saveSettings(CloudSettings settings) async {}

  void setupDropBoxToken(String authorizationCode) async {
    emit(CloudSettingsState(
        settings: null, waitingForToken: false, loading: true));
    try {
      await remoteDataProvider
          .getToken({'authorizationCode': authorizationCode});
      final response = await remoteDataProvider.createRootDirectory();
      emit(CloudSettingsState(
          settings: CloudSettings(rootPath: '', o2token: authorizationCode),
          waitingForToken: false,
          loading: false));
    } catch (ex) {
      emit(CloudSettingsState(
          settings: CloudSettings(rootPath: '', o2token: authorizationCode),
          waitingForToken: false,
          loading: false,
          error: ex.toString()));
    }
  }

  bool isAuthorized() {
    return serviceLocator.getDropboxService().isAuthorized();
  }

  void startWithDropBox() {
    emit(CloudSettingsState(
        settings: CloudSettings(rootPath: '', o2token: ''),
        waitingForToken: true));
    remoteDataProvider.authorize({});
  }
}

class CloudSettingsState {
  CloudSettingsState(
      {required this.settings,
      this.waitingForToken = false,
      this.loading = false,
      this.error});

  final CloudSettings? settings;
  final bool waitingForToken;
  final bool loading;
  final String? error;

  factory CloudSettingsState.initial() {
    return CloudSettingsState(settings: null);
  }
}
