import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kyure/data/models/account_group.dart';

part 'accounts_data.freezed.dart';
part 'accounts_data.g.dart';

@unfreezed
class AccountsData with _$AccountsData {
  factory AccountsData(
      {@JsonKey(name: 'accounts_data')
      required List<AccountGroup> accountGroups}) = _AccountsData;

  factory AccountsData.fromJson(Map<String, dynamic> json) =>
      _$AccountsDataFromJson(json);
}
