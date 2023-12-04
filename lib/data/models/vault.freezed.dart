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
  @JsonKey(name: 'version')
  int get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'version')
  set version(int value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'vault_name')
  String get vaultName => throw _privateConstructorUsedError;
  @JsonKey(name: 'vault_name')
  set vaultName(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'datacrypt')
  String get datacrypt => throw _privateConstructorUsedError;
  @JsonKey(name: 'datacrypt')
  set datacrypt(String value) => throw _privateConstructorUsedError;
  @JsonKey(includeToJson: false, includeFromJson: false)
  VaultData? get accountsData => throw _privateConstructorUsedError;
  @JsonKey(includeToJson: false, includeFromJson: false)
  set accountsData(VaultData? value) => throw _privateConstructorUsedError;

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
      {@JsonKey(name: 'version') int version,
      @JsonKey(name: 'vault_name') String vaultName,
      @JsonKey(name: 'datacrypt') String datacrypt,
      @JsonKey(includeToJson: false, includeFromJson: false)
      VaultData? accountsData});

  $VaultDataCopyWith<$Res>? get accountsData;
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
    Object? version = null,
    Object? vaultName = null,
    Object? datacrypt = null,
    Object? accountsData = freezed,
  }) {
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      vaultName: null == vaultName
          ? _value.vaultName
          : vaultName // ignore: cast_nullable_to_non_nullable
              as String,
      datacrypt: null == datacrypt
          ? _value.datacrypt
          : datacrypt // ignore: cast_nullable_to_non_nullable
              as String,
      accountsData: freezed == accountsData
          ? _value.accountsData
          : accountsData // ignore: cast_nullable_to_non_nullable
              as VaultData?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $VaultDataCopyWith<$Res>? get accountsData {
    if (_value.accountsData == null) {
      return null;
    }

    return $VaultDataCopyWith<$Res>(_value.accountsData!, (value) {
      return _then(_value.copyWith(accountsData: value) as $Val);
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
      {@JsonKey(name: 'version') int version,
      @JsonKey(name: 'vault_name') String vaultName,
      @JsonKey(name: 'datacrypt') String datacrypt,
      @JsonKey(includeToJson: false, includeFromJson: false)
      VaultData? accountsData});

  @override
  $VaultDataCopyWith<$Res>? get accountsData;
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
    Object? version = null,
    Object? vaultName = null,
    Object? datacrypt = null,
    Object? accountsData = freezed,
  }) {
    return _then(_$VaultImpl(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      vaultName: null == vaultName
          ? _value.vaultName
          : vaultName // ignore: cast_nullable_to_non_nullable
              as String,
      datacrypt: null == datacrypt
          ? _value.datacrypt
          : datacrypt // ignore: cast_nullable_to_non_nullable
              as String,
      accountsData: freezed == accountsData
          ? _value.accountsData
          : accountsData // ignore: cast_nullable_to_non_nullable
              as VaultData?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VaultImpl implements _Vault {
  _$VaultImpl(
      {@JsonKey(name: 'version') required this.version,
      @JsonKey(name: 'vault_name') required this.vaultName,
      @JsonKey(name: 'datacrypt') required this.datacrypt,
      @JsonKey(includeToJson: false, includeFromJson: false)
      this.accountsData});

  factory _$VaultImpl.fromJson(Map<String, dynamic> json) =>
      _$$VaultImplFromJson(json);

  @override
  @JsonKey(name: 'version')
  int version;
  @override
  @JsonKey(name: 'vault_name')
  String vaultName;
  @override
  @JsonKey(name: 'datacrypt')
  String datacrypt;
  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  VaultData? accountsData;

  @override
  String toString() {
    return 'Vault(version: $version, vaultName: $vaultName, datacrypt: $datacrypt, accountsData: $accountsData)';
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
      {@JsonKey(name: 'version') required int version,
      @JsonKey(name: 'vault_name') required String vaultName,
      @JsonKey(name: 'datacrypt') required String datacrypt,
      @JsonKey(includeToJson: false, includeFromJson: false)
      VaultData? accountsData}) = _$VaultImpl;

  factory _Vault.fromJson(Map<String, dynamic> json) = _$VaultImpl.fromJson;

  @override
  @JsonKey(name: 'version')
  int get version;
  @JsonKey(name: 'version')
  set version(int value);
  @override
  @JsonKey(name: 'vault_name')
  String get vaultName;
  @JsonKey(name: 'vault_name')
  set vaultName(String value);
  @override
  @JsonKey(name: 'datacrypt')
  String get datacrypt;
  @JsonKey(name: 'datacrypt')
  set datacrypt(String value);
  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  VaultData? get accountsData;
  @JsonKey(includeToJson: false, includeFromJson: false)
  set accountsData(VaultData? value);
  @override
  @JsonKey(ignore: true)
  _$$VaultImplCopyWith<_$VaultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
