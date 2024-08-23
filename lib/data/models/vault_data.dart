import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kyure/data/utils/url_utils.dart';

part 'vault_data.freezed.dart';

part 'vault_data.g.dart';

@unfreezed
class VaultData with _$VaultData {
  factory VaultData({
    @JsonKey(name: 'accounts') required Map<int, Account> accounts,
    @JsonKey(name: 'del_accounts') required Map<int, Account> deletedAccounts,
    @JsonKey(name: 'groups') required Map<int, AccountGroup> groups,
    @JsonKey(name: 'del_groups') required Map<int, AccountGroup> deletedGroups,
    @JsonKey(name: 'sort') required SortBy sort,
    @JsonKey(name: 'modif_date') required DateTime modifDate,
  }) = _VaultData;

  factory VaultData.fromJson(Map<String, dynamic> json) =>
      _$VaultDataFromJson(json);
}

@unfreezed
class AccountGroup with _$AccountGroup {
  factory AccountGroup({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'icon') required String iconName,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'color') required int color,
    @JsonKey(name: 'modif_date') required DateTime modifDate,
    @JsonKey(name: 'status') required LifeStatus status,
  }) = _AccountGroup;

  factory AccountGroup.fromJson(Map<String, dynamic> json) =>
      _$AccountGroupFromJson(json);
}

@unfreezed
class Account with _$Account {
  factory Account({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'group_id') required int groupId,
    @JsonKey(name: 'status') required LifeStatus status,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'modif_date') required DateTime modifDate,
    @JsonKey(name: 'image') required ImageSource image,
    @Default(null) @JsonKey(name: 'url') AccountField? fieldUrl,
    @JsonKey(name: 'username') required AccountField fieldUsername,
    @JsonKey(name: 'password') required AccountField fieldPassword,
    @JsonKey(name: 'fields') List<AccountField>? fieldList,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}

@unfreezed
class AccountField with _$AccountField {
  factory AccountField(
      {@JsonKey(name: 'name') required String name,
      @JsonKey(name: 'data') required String data,
      @JsonKey(name: 'visible') @Default(true) bool visible}) = _AccountField;

  factory AccountField.fromJson(Map<String, dynamic> json) =>
      _$AccountFieldFromJson(json);
}

@unfreezed
class ImageSource with _$ImageSource {
  factory ImageSource({
    @JsonKey(name: 'path') required String path,
    @JsonKey(name: 'source') required ImageSourceType source,
  }) = _ImageSource;

  factory ImageSource.fromJson(Map<String, dynamic> json) =>
      _$ImageSourceFromJson(json);
}

extension AccountExt on Account {
  AccountField? getURLField() {
    if (fieldUrl != null) return fieldUrl;
    if (fieldList?.isNotEmpty ?? false) {
      for (AccountField field in fieldList!) {
        if (field.name.isNotEmpty && field.visible && isURL(field.data)) {
          String name = field.name.trim().toLowerCase();
          if (name.contains('url') ||
              name.contains('link') ||
              name.contains('web') ||
              name.contains('uri')) {
            fieldUrl = field;
            return fieldUrl;
          }
        }
      }
    }
    fieldUrl = null;
    return null;
  }
}

enum LifeStatus {
  active(1),
  deleted(2);

  const LifeStatus(this.value);

  final int value;

  factory LifeStatus.fromJson(int json) {
    for (LifeStatus status in LifeStatus.values) {
      if (status.value == json) return status;
    }
    return LifeStatus.active;
  }

  int toJson() {
    return value;
  }
}

enum SortBy {
  nameAsc(1),
  nameDesc(-1),
  modifDateAsc(2),
  modifDateDesc(-2);

  const SortBy(this.value);

  final int value;

  factory SortBy.fromJson(int value) {
    for (SortBy sort in SortBy.values) {
      if (sort.value == value) return sort;
    }
    return SortBy.nameAsc;
  }

  int toJson() {
    return value;
  }
}

enum ImageSourceType {
  asset('asset'),
  network('network'),
  file('file');

  const ImageSourceType(this.value);

  final String value;

  factory ImageSourceType.fromJson(String json) {
    for (ImageSourceType sourceType in ImageSourceType.values) {
      if (sourceType.value == json) return sourceType;
    }
    return ImageSourceType.asset;
  }

  String toJson() {
    return value;
  }
}
