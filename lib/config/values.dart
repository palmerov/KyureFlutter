import 'package:flutter/material.dart';
import 'package:kyure/data/models/vault_data.dart';

const String VAULT_FILE_EXTENSION = '.kiure';
const String VAULT_REGISTER_FILE_NAME = 'register.reg';
const String VAULTS_DIR_NAME = 'vaults';
final AccountGroup GROUP_ALL = AccountGroup(
  name: 'Todos',
  color: Colors.blue.shade700.value,
  iconName: 'assets/svg_icons/widgets.svg',
  id: -1,
  modifDate: DateTime.now(),
  status: LifeStatus.active,
);
