import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:kyure/services/user_data_service.dart';

class LockPageBloc extends Cubit<LockPageState> {
  late KiureService vaultService;
  final bool blockedByUser;
  String? vaultNameCreated;

  LockPageBloc(this.blockedByUser) : super(const LockPageInitialState()) {
    vaultService = serviceLocator.getKiureService();
  }

  pickFile() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.any);
    if (result != null) {
      File file = File(result.files.single.path!);
      try {
        bool possible = await vaultService.importVault(file);
        if (possible) {
          emit(LockPageState(
              vaultNames: vaultService.vaultNames,
              selectedVault: vaultService.vaultName));
        } else {
          emit(LockMessageState(
              message:
                  """La bóveda que estás tratando de importar ya existe en local, con una versión superior.
Por favor, elimine la bóveda existente llamada "${vaultService.vaultName!}" o cambie su nombre.
Para hacerlo debe ingresar en ella antes."""));
        }
      } catch (exception) {
        emit(LockMessageState(
            message:
                """Ha habido un error al importar la bóveda llamada "${vaultService.vaultName!}".
Detalles del error ${exception.toString()}."""));
      }
    }
  }

  Future<String?> openVault(String key) async {
    if (key.length < 4) {
      return 'La llave debe tener al menos 4 caracteres';
    }
    vaultService.key = key;
    try {
      await vaultService.readVaultData();
      emit(const LockPageLoginState());
    } catch (exception) {
      print(exception.toString());
      return 'Llave incorrecta';
    }
    return null;
  }

  initVaultService() async {
    await vaultService.init();
    emit(LockPageState(
        vaultNames: vaultService.vaultNames,
        selectedVault: vaultService.vaultName));
  }

  selectVault(String vaultName) {
    vaultService.vaultName = vaultName;
    emit(LockPageState(
        vaultNames: vaultService.vaultNames, selectedVault: vaultName));
  }

  createVault() {
    emit(const LockPageCreatingVaultState(message: null, valid: false));
  }

  validateName(String vaultName) {
    vaultNameCreated = vaultName;
    if (vaultService.existVault(vaultName)) {
      emit(const LockPageCreatingVaultState(
          message: 'Ya existe una bóveda con ese nombre', valid: false));
    } else {
      emit(const LockPageCreatingVaultState(message: null, valid: true));
    }
  }

  Future<String?> createNewVault(String key) async {
    try {
      vaultService.key = key;
      await vaultService.createNewVault(vaultNameCreated!);
      emit(const LockPageLoginState());
    } catch (exception) {
      print(exception.toString());
      return 'Error al crear la bóveda';
    }
    return null;
  }
}

class LockPageState extends Equatable {
  const LockPageState({required this.vaultNames, this.selectedVault, this.loaded = true});
  final List<String> vaultNames;
  final String? selectedVault;
  final bool loaded;

  @override
  List<Object> get props => [vaultNames, selectedVault ?? ''];
}

class LockPageInitialState extends LockPageState {
  const LockPageInitialState() : super(vaultNames: const [], loaded: false);
}

class LockPageLoginState extends LockPageState {
  const LockPageLoginState() : super(vaultNames: const []);
}

class LockPageCreatingVaultState extends LockPageState {
  const LockPageCreatingVaultState({required this.message, required this.valid})
      : super(vaultNames: const []);
  final String? message;
  final bool valid;

  @override
  List<Object> get props => [message ?? '', valid];
}

class LockMessageState extends LockPageState {
  const LockMessageState({required this.message}) : super(vaultNames: const []);
  final String message;

  @override
  List<Object> get props => [message];
}
