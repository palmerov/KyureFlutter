import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kyure/data/models/account.dart';

part 'account_group.g.dart';
part 'account_group.freezed.dart';

@unfreezed
class AccountGroup with _$AccountGroup {
  factory AccountGroup(
          {@JsonKey(name: 'icon') required String iconName,
          @JsonKey(name: 'name') required String name,
          @JsonKey(name: 'accounts') required List<Account> accounts}) =
      _AccountGroup;

  factory AccountGroup.fromJson(Map<String, dynamic> json) =>
      _$AccountGroupFromJson(json);
}
