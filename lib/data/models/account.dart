import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kyure/data/models/account_field.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@unfreezed
class Account with _$Account {
  factory Account({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required final String name,
    @JsonKey(name: 'username') required AccountField fieldUsername,
    @JsonKey(name: 'password') required AccountField fieldPassword,
    @JsonKey(name: 'fields') required List<AccountField> fieldList,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

}
