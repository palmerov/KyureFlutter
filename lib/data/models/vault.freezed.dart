// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vault.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Vault _$VaultFromJson(Map<String, dynamic> json) {
  return _Vault.fromJson(json);
}

/// @nodoc
mixin _$Vault {
  @JsonKey(name: 'vault_name')
  String get vaultName => throw _privateConstructorUsedError;
  @JsonKey(name: 'vault_name')
  set vaultName(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'version')
  DateTime get modifDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'version')
  set modifDate(DateTime value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'datacrypt')
  String get datacrypt => throw _privateConstructorUsedError;
  @JsonKey(name: 'datacrypt')
  set datacrypt(String value) => throw _privateConstructorUsedError;
  @JsonKey(includeToJson: false, includeFromJson: false)
  VaultData? get data => throw _privateConstructorUsedError;
  @JsonKey(includeToJson: false, includeFromJson: false)
  set data(VaultData? value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VaultCopyWith<Vault> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaultCopyWith<$Res> {
  factory $VaultCopyWith(Vault value, $Res Function(Vault) then) =
      _$VaultCopyWithImpl<$Res, Vault>;
  @useResult
  $Res call(
      {@JsonKey(name: 'vault_name') String vaultName,
      @JsonKey(name: 'version') DateTime modifDate,
      @JsonKey(name: 'datacrypt') String datacrypt,
      @JsonKey(includeToJson: false, includeFromJson: false) VaultData? data});

  $VaultDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$VaultCopyWithImpl<$Res, $Val extends Vault>
    implements $VaultCopyWith<$Res> {
  _$VaultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vaultName = null,
    Object? modifDate = null,
    Object? datacrypt = null,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      vaultName: null == vaultName
          ? _value.vaultName
          : vaultName // ignore: cast_nullable_to_non_nullable
              as String,
      modifDate: null == modifDate
          ? _value.modifDate
          : modifDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      datacrypt: null == datacrypt
          ? _value.datacrypt
          : datacrypt // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as VaultData?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $VaultDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $VaultDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VaultImplCopyWith<$Res> implements $VaultCopyWith<$Res> {
  factory _$$VaultImplCopyWith(
          _$VaultImpl value, $Res Function(_$VaultImpl) then) =
      __$$VaultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'vault_name') String vaultName,
      @JsonKey(name: 'version') DateTime modifDate,
      @JsonKey(name: 'datacrypt') String datacrypt,
      @JsonKey(includeToJson: false, includeFromJson: false) VaultData? data});

  @override
  $VaultDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$VaultImplCopyWithImpl<$Res>
    extends _$VaultCopyWithImpl<$Res, _$VaultImpl>
    implements _$$VaultImplCopyWith<$Res> {
  __$$VaultImplCopyWithImpl(
      _$VaultImpl _value, $Res Function(_$VaultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vaultName = null,
    Object? modifDate = null,
    Object? datacrypt = null,
    Object? data = freezed,
  }) {
    return _then(_$VaultImpl(
      vaultName: null == vaultName
          ? _value.vaultName
          : vaultName // ignore: cast_nullable_to_non_nullable
              as String,
      modifDate: null == modifDate
          ? _value.modifDate
          : modifDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      datacrypt: null == datacrypt
          ? _value.datacrypt
          : datacrypt // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as VaultData?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VaultImpl implements _Vault {
  _$VaultImpl(
      {@JsonKey(name: 'vault_name') required this.vaultName,
      @JsonKey(name: 'version') required this.modifDate,
      @JsonKey(name: 'datacrypt') required this.datacrypt,
      @JsonKey(includeToJson: false, includeFromJson: false) this.data});

  factory _$VaultImpl.fromJson(Map<String, dynamic> json) =>
      _$$VaultImplFromJson(json);

  @override
  @JsonKey(name: 'vault_name')
  String vaultName;
  @override
  @JsonKey(name: 'version')
  DateTime modifDate;
  @override
  @JsonKey(name: 'datacrypt')
  String datacrypt;
  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  VaultData? data;

  @override
  String toString() {
    return 'Vault(vaultName: $vaultName, modifDate: $modifDate, datacrypt: $datacrypt, data: $data)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VaultImplCopyWith<_$VaultImpl> get copyWith =>
      __$$VaultImplCopyWithImpl<_$VaultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VaultImplToJson(
      this,
    );
  }
}

abstract class _Vault implements Vault {
  factory _Vault(
      {@JsonKey(name: 'vault_name') required String vaultName,
      @JsonKey(name: 'version') required DateTime modifDate,
      @JsonKey(name: 'datacrypt') required String datacrypt,
      @JsonKey(includeToJson: false, includeFromJson: false)
      VaultData? data}) = _$VaultImpl;

  factory _Vault.fromJson(Map<String, dynamic> json) = _$VaultImpl.fromJson;

  @override
  @JsonKey(name: 'vault_name')
  String get vaultName;
  @JsonKey(name: 'vault_name')
  set vaultName(String value);
  @override
  @JsonKey(name: 'version')
  DateTime get modifDate;
  @JsonKey(name: 'version')
  set modifDate(DateTime value);
  @override
  @JsonKey(name: 'datacrypt')
  String get datacrypt;
  @JsonKey(name: 'datacrypt')
  set datacrypt(String value);
  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  VaultData? get data;
  @JsonKey(includeToJson: false, includeFromJson: false)
  set data(VaultData? value);
  @override
  @JsonKey(ignore: true)
  _$$VaultImplCopyWith<_$VaultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
