// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vault_register.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RepositoryRegister _$RepositoryRegisterFromJson(Map<String, dynamic> json) {
  return _RepositoryRegister.fromJson(json);
}

/// @nodoc
mixin _$RepositoryRegister {
  @JsonKey(name: 'registers')
  List<VaultRegister> get registers => throw _privateConstructorUsedError;
  @JsonKey(name: 'registers')
  set registers(List<VaultRegister> value) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RepositoryRegisterCopyWith<RepositoryRegister> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RepositoryRegisterCopyWith<$Res> {
  factory $RepositoryRegisterCopyWith(
          RepositoryRegister value, $Res Function(RepositoryRegister) then) =
      _$RepositoryRegisterCopyWithImpl<$Res, RepositoryRegister>;
  @useResult
  $Res call({@JsonKey(name: 'registers') List<VaultRegister> registers});
}

/// @nodoc
class _$RepositoryRegisterCopyWithImpl<$Res, $Val extends RepositoryRegister>
    implements $RepositoryRegisterCopyWith<$Res> {
  _$RepositoryRegisterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? registers = null,
  }) {
    return _then(_value.copyWith(
      registers: null == registers
          ? _value.registers
          : registers // ignore: cast_nullable_to_non_nullable
              as List<VaultRegister>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RepositoryRegisterImplCopyWith<$Res>
    implements $RepositoryRegisterCopyWith<$Res> {
  factory _$$RepositoryRegisterImplCopyWith(_$RepositoryRegisterImpl value,
          $Res Function(_$RepositoryRegisterImpl) then) =
      __$$RepositoryRegisterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'registers') List<VaultRegister> registers});
}

/// @nodoc
class __$$RepositoryRegisterImplCopyWithImpl<$Res>
    extends _$RepositoryRegisterCopyWithImpl<$Res, _$RepositoryRegisterImpl>
    implements _$$RepositoryRegisterImplCopyWith<$Res> {
  __$$RepositoryRegisterImplCopyWithImpl(_$RepositoryRegisterImpl _value,
      $Res Function(_$RepositoryRegisterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? registers = null,
  }) {
    return _then(_$RepositoryRegisterImpl(
      registers: null == registers
          ? _value.registers
          : registers // ignore: cast_nullable_to_non_nullable
              as List<VaultRegister>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RepositoryRegisterImpl implements _RepositoryRegister {
  _$RepositoryRegisterImpl(
      {@JsonKey(name: 'registers') required this.registers});

  factory _$RepositoryRegisterImpl.fromJson(Map<String, dynamic> json) =>
      _$$RepositoryRegisterImplFromJson(json);

  @override
  @JsonKey(name: 'registers')
  List<VaultRegister> registers;

  @override
  String toString() {
    return 'RepositoryRegister(registers: $registers)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RepositoryRegisterImplCopyWith<_$RepositoryRegisterImpl> get copyWith =>
      __$$RepositoryRegisterImplCopyWithImpl<_$RepositoryRegisterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RepositoryRegisterImplToJson(
      this,
    );
  }
}

abstract class _RepositoryRegister implements RepositoryRegister {
  factory _RepositoryRegister(
      {@JsonKey(name: 'registers')
      required List<VaultRegister> registers}) = _$RepositoryRegisterImpl;

  factory _RepositoryRegister.fromJson(Map<String, dynamic> json) =
      _$RepositoryRegisterImpl.fromJson;

  @override
  @JsonKey(name: 'registers')
  List<VaultRegister> get registers;
  @JsonKey(name: 'registers')
  set registers(List<VaultRegister> value);
  @override
  @JsonKey(ignore: true)
  _$$RepositoryRegisterImplCopyWith<_$RepositoryRegisterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VaultRegister _$VaultRegisterFromJson(Map<String, dynamic> json) {
  return _VaultRegister.fromJson(json);
}

/// @nodoc
mixin _$VaultRegister {
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  set name(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'modif_date')
  DateTime get modifDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'modif_date')
  set modifDate(DateTime value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'path')
  String get path => throw _privateConstructorUsedError;
  @JsonKey(name: 'path')
  set path(String value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VaultRegisterCopyWith<VaultRegister> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaultRegisterCopyWith<$Res> {
  factory $VaultRegisterCopyWith(
          VaultRegister value, $Res Function(VaultRegister) then) =
      _$VaultRegisterCopyWithImpl<$Res, VaultRegister>;
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String name,
      @JsonKey(name: 'modif_date') DateTime modifDate,
      @JsonKey(name: 'path') String path});
}

/// @nodoc
class _$VaultRegisterCopyWithImpl<$Res, $Val extends VaultRegister>
    implements $VaultRegisterCopyWith<$Res> {
  _$VaultRegisterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? modifDate = null,
    Object? path = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      modifDate: null == modifDate
          ? _value.modifDate
          : modifDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VaultRegisterImplCopyWith<$Res>
    implements $VaultRegisterCopyWith<$Res> {
  factory _$$VaultRegisterImplCopyWith(
          _$VaultRegisterImpl value, $Res Function(_$VaultRegisterImpl) then) =
      __$$VaultRegisterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String name,
      @JsonKey(name: 'modif_date') DateTime modifDate,
      @JsonKey(name: 'path') String path});
}

/// @nodoc
class __$$VaultRegisterImplCopyWithImpl<$Res>
    extends _$VaultRegisterCopyWithImpl<$Res, _$VaultRegisterImpl>
    implements _$$VaultRegisterImplCopyWith<$Res> {
  __$$VaultRegisterImplCopyWithImpl(
      _$VaultRegisterImpl _value, $Res Function(_$VaultRegisterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? modifDate = null,
    Object? path = null,
  }) {
    return _then(_$VaultRegisterImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      modifDate: null == modifDate
          ? _value.modifDate
          : modifDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VaultRegisterImpl implements _VaultRegister {
  _$VaultRegisterImpl(
      {@JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'modif_date') required this.modifDate,
      @JsonKey(name: 'path') required this.path});

  factory _$VaultRegisterImpl.fromJson(Map<String, dynamic> json) =>
      _$$VaultRegisterImplFromJson(json);

  @override
  @JsonKey(name: 'name')
  String name;
  @override
  @JsonKey(name: 'modif_date')
  DateTime modifDate;
  @override
  @JsonKey(name: 'path')
  String path;

  @override
  String toString() {
    return 'VaultRegister(name: $name, modifDate: $modifDate, path: $path)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VaultRegisterImplCopyWith<_$VaultRegisterImpl> get copyWith =>
      __$$VaultRegisterImplCopyWithImpl<_$VaultRegisterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VaultRegisterImplToJson(
      this,
    );
  }
}

abstract class _VaultRegister implements VaultRegister {
  factory _VaultRegister(
      {@JsonKey(name: 'name') required String name,
      @JsonKey(name: 'modif_date') required DateTime modifDate,
      @JsonKey(name: 'path') required String path}) = _$VaultRegisterImpl;

  factory _VaultRegister.fromJson(Map<String, dynamic> json) =
      _$VaultRegisterImpl.fromJson;

  @override
  @JsonKey(name: 'name')
  String get name;
  @JsonKey(name: 'name')
  set name(String value);
  @override
  @JsonKey(name: 'modif_date')
  DateTime get modifDate;
  @JsonKey(name: 'modif_date')
  set modifDate(DateTime value);
  @override
  @JsonKey(name: 'path')
  String get path;
  @JsonKey(name: 'path')
  set path(String value);
  @override
  @JsonKey(ignore: true)
  _$$VaultRegisterImplCopyWith<_$VaultRegisterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
