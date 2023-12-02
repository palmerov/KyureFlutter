import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:kyure/services/user_data_service.dart';

class LockPageBloc extends Cubit<LockPageState> {
  late UserDataService userDataService;
  final bool blockedByUser;

  LockPageBloc(this.blockedByUser) : super(LockPageInitial()) {
    userDataService = serviceLocator.getUserDataService();
  }

  pickFile() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.any);
    if (result != null) {
      File file = File(result.files.single.path!);
      insertFile(file.path);
    }
  }

  createFile() async {
    userDataService.path = null;
    emit(LockInsertKeyState(
        createKey: userDataService.path == null ||
            (await File(userDataService.path!).length()) < 10,
        error: false));
  }

  loadPrefs() async {
    await userDataService.loadPrefs();
    findKiureFile();
  }

  findKiureFile() async {
    bool existFile = await userDataService.evaluateFile();
    if (existFile) {
      emit(LockInsertKeyState(
          createKey: (await File(userDataService.path!).length()) < 10,
          error: false));
    } else {
      emit(LockInsertFileState());
    }
  }

  insertFile(String path) async {
    userDataService.path = path;
    findKiureFile();
  }

  insertKey(String key) async {
    userDataService.key = key;
    await userDataService.readUserData();
    emit(LockPageInitial());
  }

  initWithKey(String key, bool newFile) async {
    userDataService.key = key;
    if (newFile) {
      await userDataService.createNewFile();
      emit(LockPageLogin());
    } else {
      try {
        await userDataService.readUserData();
        emit(LockPageLogin());
      } catch (exception) {
        print(exception.toString());
        emit(const LockInsertKeyState(createKey: false, error: true));
      }
    }
  }
}

class LockPageState extends Equatable {
  const LockPageState();

  @override
  List<Object> get props => [];
}

class LockInsertKeyState extends LockPageState {
  const LockInsertKeyState({required this.createKey, required this.error});
  final bool createKey;
  final bool error;

  @override
  List<Object> get props => [createKey, error];
}

class LockInsertFileState extends LockPageState {}

class LockPageInitial extends LockPageState {}

class LockPageLogin extends LockPageState {}
