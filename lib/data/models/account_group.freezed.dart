// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AccountGroup _$AccountGroupFromJson(Map<String, dynamic> json) {
  return _AccountGroup.fromJson(json);
}

/// @nodoc
mixin _$AccountGroup {
  @JsonKey(name: 'icon')
  String get iconName => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon')
  set iconName(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  set name(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'accounts')
  List<Account> get accounts => throw _privateConstructorUsedError;
  @JsonKey(name: 'accounts')
  set accounts(List<Account> value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AccountGroupCopyWith<AccountGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountGroupCopyWith<$Res> {
  factory $AccountGroupCopyWith(
          AccountGroup value, $Res Function(AccountGroup) then) =
      _$AccountGroupCopyWithImpl<$Res, AccountGroup>;
  @useResult
  $Res call(
      {@JsonKey(name: 'icon') String iconName,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'accounts') List<Account> accounts});
}

/// @nodoc
class _$AccountGroupCopyWithImpl<$Res, $Val extends AccountGroup>
    implements $AccountGroupCopyWith<$Res> {
  _$AccountGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? iconName = null,
    Object? name = null,
    Object? accounts = null,
  }) {
    return _then(_value.copyWith(
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      accounts: null == accounts
          ? _value.accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as List<Account>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountGroupImplCopyWith<$Res>
    implements $AccountGroupCopyWith<$Res> {
  factory _$$AccountGroupImplCopyWith(
          _$AccountGroupImpl value, $Res Function(_$AccountGroupImpl) then) =
      __$$AccountGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'icon') String iconName,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'accounts') List<Account> accounts});
}

/// @nodoc
class __$$AccountGroupImplCopyWithImpl<$Res>
    extends _$AccountGroupCopyWithImpl<$Res, _$AccountGroupImpl>
    implements _$$AccountGroupImplCopyWith<$Res> {
  __$$AccountGroupImplCopyWithImpl(
      _$AccountGroupImpl _value, $Res Function(_$AccountGroupImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? iconName = null,
    Object? name = null,
    Object? accounts = null,
  }) {
    return _then(_$AccountGroupImpl(
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      accounts: null == accounts
          ? _value.accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as List<Account>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountGroupImpl implements _AccountGroup {
  _$AccountGroupImpl(
      {@JsonKey(name: 'icon') required this.iconName,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'accounts') required this.accounts});

  factory _$AccountGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountGroupImplFromJson(json);

  @override
  @JsonKey(name: 'icon')
  String iconName;
  @override
  @JsonKey(name: 'name')
  String name;
  @override
  @JsonKey(name: 'accounts')
  List<Account> accounts;

  @override
  String toString() {
    return 'AccountGroup(iconName: $iconName, name: $name, accounts: $accounts)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountGroupImplCopyWith<_$AccountGroupImpl> get copyWith =>
      __$$AccountGroupImplCopyWithImpl<_$AccountGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountGroupImplToJson(
      this,
    );
  }
}

abstract class _AccountGroup implements AccountGroup {
  factory _AccountGroup(
          {@JsonKey(name: 'icon') required String iconName,
          @JsonKey(name: 'name') required String name,
          @JsonKey(name: 'accounts') required List<Account> accounts}) =
      _$AccountGroupImpl;

  factory _AccountGroup.fromJson(Map<String, dynamic> json) =
      _$AccountGroupImpl.fromJson;

  @override
  @JsonKey(name: 'icon')
  String get iconName;
  @JsonKey(name: 'icon')
  set iconName(String value);
  @override
  @JsonKey(name: 'name')
  String get name;
  @JsonKey(name: 'name')
  set name(String value);
  @override
  @JsonKey(name: 'accounts')
  List<Account> get accounts;
  @JsonKey(name: 'accounts')
  set accounts(List<Account> value);
  @override
  @JsonKey(ignore: true)
  _$$AccountGroupImplCopyWith<_$AccountGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
