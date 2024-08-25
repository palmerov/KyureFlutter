class VaultData {
  Map<int, Account> accounts;
  Map<int, Account> deletedAccounts;
  Map<int, AccountGroup> groups;
  Map<int, AccountGroup> deletedGroups;
  SortBy sort;
  DateTime modifDate;

  VaultData({
    required this.accounts,
    required this.deletedAccounts,
    required this.groups,
    required this.deletedGroups,
    required this.sort,
    required this.modifDate,
  });

  factory VaultData.fromJson(Map<String, dynamic> json) => VaultData(
      accounts: (json['accounts'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(int.parse(key), Account.fromJson(value))),
      deletedAccounts: (json['del_accounts'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(int.parse(key), Account.fromJson(value))),
      groups: (json['groups'] as Map<String, dynamic>).map((key, value) =>
          MapEntry(int.parse(key), AccountGroup.fromJson(value))),
      deletedGroups: (json['del_groups'] as Map<String, dynamic>).map(
          (key, value) =>
              MapEntry(int.parse(key), AccountGroup.fromJson(value))),
      sort: SortBy.fromJson(json['sort']),
      modifDate: DateTime.parse(json['modif_date']));

  Map<String, dynamic> toJson() => {
        'accounts': accounts
            .map((key, value) => MapEntry(key.toString(), value.toJson())),
        'del_accounts': deletedAccounts
            .map((key, value) => MapEntry(key.toString(), value.toJson())),
        'groups': groups
            .map((key, value) => MapEntry(key.toString(), value.toJson())),
        'del_groups': deletedGroups
            .map((key, value) => MapEntry(key.toString(), value.toJson())),
        'sort': sort.toJson(),
        'modif_date': modifDate.toIso8601String()
      };
}

class AccountGroup {
  int id;
  String iconName;
  String name;
  int color;
  DateTime modifDate;
  LifeStatus status;

  AccountGroup({
    required this.id,
    required this.iconName,
    required this.name,
    required this.color,
    required this.modifDate,
    required this.status,
  });

  factory AccountGroup.fromJson(Map<String, dynamic> json) => AccountGroup(
      id: json['id'],
      iconName: json['icon'],
      name: json['name'],
      color: json['color'],
      modifDate: DateTime.parse(json['modif_date']),
      status: LifeStatus.fromJson(json['status']));

  Map<String, dynamic> toJson() => {
        'id': id,
        'icon': iconName,
        'name': name,
        'color': color,
        'modif_date': modifDate.toIso8601String(),
        'status': status.toJson()
      };

  AccountGroup copyWith({
    int? id,
    String? iconName,
    String? name,
    int? color,
    DateTime? modifDate,
    LifeStatus? status,
  }) =>
      AccountGroup(
        id: id ?? this.id,
        iconName: iconName ?? this.iconName,
        name: name ?? this.name,
        color: color ?? this.color,
        modifDate: modifDate ?? this.modifDate,
        status: status ?? this.status,
      );
}

class Account {
  int id;
  int groupId;
  LifeStatus status;
  String name;
  DateTime modifDate;
  ImageSource image;
  AccountField fieldUsername;
  AccountField fieldPassword;
  List<AccountField>? fieldList;
  final Map<AccountFieldType, AccountField> _firstFieldList = {};

  Account({
    required this.id,
    required this.groupId,
    required this.status,
    required this.name,
    required this.modifDate,
    required this.image,
    required this.fieldUsername,
    required this.fieldPassword,
    this.fieldList,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
      id: json['id'],
      groupId: json['group_id'],
      status: LifeStatus.fromJson(json['status']),
      name: json['name'],
      modifDate: DateTime.parse(json['modif_date']),
      image: ImageSource.fromJson(json['image']),
      fieldUsername: AccountField.fromJson(json['username']),
      fieldPassword: AccountField.fromJson(json['password']),
      fieldList: json['fields']
          ?.map<AccountField>((e) => AccountField.fromJson(e))
          .toList());

  Map<String, dynamic> toJson() => {
        'id': id,
        'group_id': groupId,
        'status': status.toJson(),
        'name': name,
        'modif_date': modifDate.toIso8601String(),
        'image': image.toJson(),
        'username': fieldUsername.toJson(),
        'password': fieldPassword.toJson(),
        'fields':
            fieldList?.map<Map<String, dynamic>>((e) => e.toJson()).toList()
      };

  AccountField? firstFieldByType(AccountFieldType type) {
    if (_firstFieldList.containsKey(type)) {
      return _firstFieldList[type];
    }
    if (fieldUsername.type == type) {
      return fieldUsername;
    }
    if (fieldPassword.type == type) {
      return fieldPassword;
    }
    if (fieldList?.isNotEmpty ?? false) {
      for (AccountField field in fieldList!) {
        if (field.type == type) {
          _firstFieldList[type] = field;
          return field;
        }
      }
    }
    return null;
  }

  /// Returns fields that matches with type condition
  /// @param matchesType: if false, negates the matching condition
  List<AccountField> fieldsByType(AccountFieldType type,
      [bool matchesType = true, bool acceptsEmpty = false]) {
    return fieldsByTypeMatcher(
        (t) => (t == type && matchesType) || (t != type && !matchesType),
        acceptsEmpty);
  }

  List<AccountField> fieldsToCopy(bool hidden) {
    return fieldsByTypeMatcher((t) => hidden
        ? t == AccountFieldType.password
        : t == AccountFieldType.text ||
            t == AccountFieldType.email ||
            t == AccountFieldType.number ||
            t == AccountFieldType.phone);
  }

  List<AccountField> fieldsByTypeMatcher(
      bool Function(AccountFieldType t) matcher,
      [bool acceptsEmpty = false]) {
    List<AccountField> list = [];
    if (matcher(fieldUsername.type)) {
      if (acceptsEmpty || fieldUsername.data.isNotEmpty) {
        list.add(fieldUsername);
      }
    }
    if (matcher(fieldPassword.type)) {
      if(acceptsEmpty || fieldPassword.data.isNotEmpty) {
        list.add(fieldPassword);
      }
    }
    if (fieldList?.isNotEmpty ?? false) {
      return list +
          fieldList!
              .where((e) => matcher(e.type) && fieldPassword.data.isNotEmpty)
              .toList();
    }
    return list;
  }

  factory Account.emptyWith({
    int? id,
    int? groupId,
    LifeStatus? status,
    String? name,
    DateTime? modifDate,
    ImageSource? image,
  }) {
    return Account(
        id: id ?? -1,
        groupId: groupId ?? -1,
        modifDate: modifDate ?? DateTime.now(),
        status: status ?? LifeStatus.active,
        name: name ?? '',
        image: image ??
            ImageSource(
                source: ImageSourceType.asset,
                data: 'assets/web_icons/squared.png'),
        fieldUsername: AccountField(name: 'Nombre de usuario', data: ''),
        fieldPassword: AccountField(
            name: 'Contraseña', data: '', type: AccountFieldType.password));
  }
}

class AccountField {
  String name;
  String data;
  AccountFieldType type;

  AccountField({
    required this.name,
    required this.data,
    this.type = AccountFieldType.text,
  });

  factory AccountField.fromJson(Map<String, dynamic> json) {
    AccountFieldType type;
    if (json.containsKey('visible')) {
      type = AccountFieldType.fromJson(json['visible']);
    } else {
      type = AccountFieldType.fromJson(json['type']);
    }
    return AccountField(name: json['name'], data: json['data'], type: type);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'data': data,
        'type': type.toJson(),
      };

  bool get isPassword => type == AccountFieldType.password;

  bool get isUrl => type == AccountFieldType.url;

  bool get isEmail => type == AccountFieldType.email;

  bool get isPhone => type == AccountFieldType.phone;

  bool get isText => type == AccountFieldType.text;

  bool get isNumber => type == AccountFieldType.number;

  bool get isQr => type == AccountFieldType.qr;
}

class ImageSource {
  String data;
  ImageSourceType source;

  ImageSource({required this.data, required this.source});

  factory ImageSource.fromJson(Map<String, dynamic> json) {
    String data = '', sourceType = '';
    if (json.containsKey('data')) {
      data = json['data'];
    } else if (json.containsKey('path')) {
      data = json['path'];
    }
    if (json.containsKey('source')) {
      sourceType = json['source'];
    }
    return ImageSource(
        data: data, source: ImageSourceType.fromJson(sourceType));
  }

  Map<String, dynamic> toJson() {
    return {'data': data, 'source': source.toJson()};
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

enum AccountFieldType {
  text('text'),
  password('password'),
  number('number'),
  qr('qr'),
  url('url'),
  email('email'),
  phone('phone');

  const AccountFieldType(this.value);

  final String value;

  factory AccountFieldType.fromJson(dynamic value) {
    if (value is bool) {
      if (value) {
        return AccountFieldType.text;
      } else {
        return AccountFieldType.password;
      }
    }
    for (AccountFieldType type in AccountFieldType.values) {
      if (type.value == value) return type;
    }
    return AccountFieldType.text;
  }

  String toJson() {
    return value;
  }

  bool get isPassword => this == AccountFieldType.password;

  bool get isUrl => this == AccountFieldType.url;

  bool get isEmail => this == AccountFieldType.email;

  bool get isPhone => this == AccountFieldType.phone;

  bool get isText => this == AccountFieldType.text;

  bool get isNumber => this == AccountFieldType.number;

  bool get isQr => this == AccountFieldType.qr;
}

enum ImageSourceType {
  asset('asset'),
  network('network'),
  svg('svg'),
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
