import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyure/data/utils/encrypt_utils.dart';
import 'package:kyure/services/kiure_service.dart';
import 'package:kyure/services/service_locator.dart';
import 'package:kyure/services/vault_service.dart';

class LockPageBloc extends Cubit<LockPageState> {
  late KiureService kiureService;
  late VaultService vaultService;
  final bool blockedByUser;
  String? vaultNameCreated;

  LockPageBloc(this.blockedByUser) : super(LockPageInitialState()) {
    kiureService = serviceLocator.getKiureService();
    vaultService = serviceLocator.getVaultService();
  }

  emitLoginState() {
    emit(LockPageLoginState());
  }

  pickFile() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.any);
    if (result != null) {
      File file = File(result.files.single.path!);
      try {
        bool possible = !vaultService.existVaultFileInLocal(file);
        if (possible) {
          emit(LockPageState(
              vaultNames: vaultService.localVaultNames,
              selectedVault: vaultService.vaultName));
        } else {
          String name = vaultService.getVaultNameFromFile(file);
          emit(LockMessageState(
              message:
                  """La bóveda "$name" ya existe localmente.
Debes ingresar en ella y usar la opción "Sincronizar desde archivo" para actualizarla."""));
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
    try {
      await vaultService.openVault(
          state.selectedVault ?? '', EncryptAlgorithm.AES, key);
      emitLoginState();
    } catch (exception) {
      print(exception.toString());
      return 'Llave incorrecta';
    }
    return null;
  }

  initVaultService() async {
    await kiureService.init();
    emit(LockPageState(
        vaultNames: vaultService.localVaultNames,
        selectedVault: vaultService.vaultName));
  }

  selectVault(String vaultName) {
    vaultService.vaultName = vaultName;
    emit(LockPageState(
        vaultNames: vaultService.localVaultNames, selectedVault: vaultName));
  }

  createVault() {
    emit(LockPageCreatingVaultState(message: null, valid: false));
  }

  validateName(String vaultName) {
    vaultNameCreated = vaultName;
    if (vaultService.existVaultInLocal(vaultName)) {
      emit(LockPageCreatingVaultState(
          message: 'Ya existe una bóveda con ese nombre', valid: false));
    } else {
      emit(LockPageCreatingVaultState(message: null, valid: true));
    }
  }

  Future<String?> createNewVault(String key) async {
    try {
      await vaultService.createNewVault(
          vaultNameCreated!, EncryptAlgorithm.AES, key);
      emitLoginState();
    } catch (exception) {
      print(exception.toString());
      return 'Error al crear la bóveda';
    }
    return null;
  }
}

class LockPageState extends Equatable {
  LockPageState(
      {required List<String> vaultNames,
      this.selectedVault,
      this.loaded = true}) {
    this.vaultNames = [...vaultNames];
  }
  late final List<String> vaultNames;
  final String? selectedVault;
  final bool loaded;

  @override
  List<Object> get props => [vaultNames.length, selectedVault ?? '', loaded];
}

class LockPageInitialState extends LockPageState {
  LockPageInitialState() : super(vaultNames: const [], loaded: false);
}

class LockPageLoginState extends LockPageState {
  LockPageLoginState() : super(vaultNames: const []);
}

class LockPageCreatingVaultState extends LockPageState {
  LockPageCreatingVaultState({required this.message, required this.valid})
      : super(vaultNames: const []);
  final String? message;
  final bool valid;

  @override
  List<Object> get props => [message ?? '', valid];
}

class LockMessageState extends LockPageState {
  LockMessageState({required this.message}) : super(vaultNames: const []);
  final String message;

  @override
  List<Object> get props => [message];
}
