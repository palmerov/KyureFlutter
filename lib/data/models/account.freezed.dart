// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Account _$AccountFromJson(Map<String, dynamic> json) {
  return _Account.fromJson(json);
}

/// @nodoc
mixin _$Account {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'id')
  set id(int value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'username')
  AccountField get fieldUsername => throw _privateConstructorUsedError;
  @JsonKey(name: 'username')
  set fieldUsername(AccountField value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'password')
  AccountField get fieldPassword => throw _privateConstructorUsedError;
  @JsonKey(name: 'password')
  set fieldPassword(AccountField value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'fields')
  List<AccountField> get fieldList => throw _privateConstructorUsedError;
  @JsonKey(name: 'fields')
  set fieldList(List<AccountField> value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AccountCopyWith<Account> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res, Account>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'username') AccountField fieldUsername,
      @JsonKey(name: 'password') AccountField fieldPassword,
      @JsonKey(name: 'fields') List<AccountField> fieldList});

  $AccountFieldCopyWith<$Res> get fieldUsername;
  $AccountFieldCopyWith<$Res> get fieldPassword;
}

/// @nodoc
class _$AccountCopyWithImpl<$Res, $Val extends Account>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? fieldUsername = null,
    Object? fieldPassword = null,
    Object? fieldList = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      fieldUsername: null == fieldUsername
          ? _value.fieldUsername
          : fieldUsername // ignore: cast_nullable_to_non_nullable
              as AccountField,
      fieldPassword: null == fieldPassword
          ? _value.fieldPassword
          : fieldPassword // ignore: cast_nullable_to_non_nullable
              as AccountField,
      fieldList: null == fieldList
          ? _value.fieldList
          : fieldList // ignore: cast_nullable_to_non_nullable
              as List<AccountField>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AccountFieldCopyWith<$Res> get fieldUsername {
    return $AccountFieldCopyWith<$Res>(_value.fieldUsername, (value) {
      return _then(_value.copyWith(fieldUsername: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AccountFieldCopyWith<$Res> get fieldPassword {
    return $AccountFieldCopyWith<$Res>(_value.fieldPassword, (value) {
      return _then(_value.copyWith(fieldPassword: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AccountImplCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$$AccountImplCopyWith(
          _$AccountImpl value, $Res Function(_$AccountImpl) then) =
      __$$AccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'username') AccountField fieldUsername,
      @JsonKey(name: 'password') AccountField fieldPassword,
      @JsonKey(name: 'fields') List<AccountField> fieldList});

  @override
  $AccountFieldCopyWith<$Res> get fieldUsername;
  @override
  $AccountFieldCopyWith<$Res> get fieldPassword;
}

/// @nodoc
class __$$AccountImplCopyWithImpl<$Res>
    extends _$AccountCopyWithImpl<$Res, _$AccountImpl>
    implements _$$AccountImplCopyWith<$Res> {
  __$$AccountImplCopyWithImpl(
      _$AccountImpl _value, $Res Function(_$AccountImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? fieldUsername = null,
    Object? fieldPassword = null,
    Object? fieldList = null,
  }) {
    return _then(_$AccountImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      fieldUsername: null == fieldUsername
          ? _value.fieldUsername
          : fieldUsername // ignore: cast_nullable_to_non_nullable
              as AccountField,
      fieldPassword: null == fieldPassword
          ? _value.fieldPassword
          : fieldPassword // ignore: cast_nullable_to_non_nullable
              as AccountField,
      fieldList: null == fieldList
          ? _value.fieldList
          : fieldList // ignore: cast_nullable_to_non_nullable
              as List<AccountField>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountImpl implements _Account {
  _$AccountImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'username') required this.fieldUsername,
      @JsonKey(name: 'password') required this.fieldPassword,
      @JsonKey(name: 'fields') required this.fieldList});

  factory _$AccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  int id;
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'username')
  AccountField fieldUsername;
  @override
  @JsonKey(name: 'password')
  AccountField fieldPassword;
  @override
  @JsonKey(name: 'fields')
  List<AccountField> fieldList;

  @override
  String toString() {
    return 'Account(id: $id, name: $name, fieldUsername: $fieldUsername, fieldPassword: $fieldPassword, fieldList: $fieldList)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      __$$AccountImplCopyWithImpl<_$AccountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountImplToJson(
      this,
    );
  }
}

abstract class _Account implements Account {
  factory _Account(
          {@JsonKey(name: 'id') required int id,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'username') required AccountField fieldUsername,
          @JsonKey(name: 'password') required AccountField fieldPassword,
          @JsonKey(name: 'fields') required List<AccountField> fieldList}) =
      _$AccountImpl;

  factory _Account.fromJson(Map<String, dynamic> json) = _$AccountImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @JsonKey(name: 'id')
  set id(int value);
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'username')
  AccountField get fieldUsername;
  @JsonKey(name: 'username')
  set fieldUsername(AccountField value);
  @override
  @JsonKey(name: 'password')
  AccountField get fieldPassword;
  @JsonKey(name: 'password')
  set fieldPassword(AccountField value);
  @override
  @JsonKey(name: 'fields')
  List<AccountField> get fieldList;
  @JsonKey(name: 'fields')
  set fieldList(List<AccountField> value);
  @override
  @JsonKey(ignore: true)
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
