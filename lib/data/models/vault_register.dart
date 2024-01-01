import 'package:freezed_annotation/freezed_annotation.dart';
part 'vault_register.freezed.dart';
part 'vault_register.g.dart';

@unfreezed
class RepositoryRegister with _$RepositoryRegister {
  factory RepositoryRegister({
    @JsonKey(name: 'registers') required List<VaultRegister> registers,
  }) = _RepositoryRegister;

  factory RepositoryRegister.fromJson(Map<String, dynamic> json) =>
      _$RepositoryRegisterFromJson(json);
}

@unfreezed
class VaultRegister with _$VaultRegister {
  factory VaultRegister({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'modif_date') required DateTime modifDate,
    @JsonKey(name: 'path') required String path,
  }) = _VaultRegister;

  factory VaultRegister.fromJson(Map<String, dynamic> json) =>
      _$VaultRegisterFromJson(json);
}
