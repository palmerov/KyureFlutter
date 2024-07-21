import 'package:flutter/material.dart';
import 'package:kyure/data/models/vault_data.dart';

const VAULT_FILE_EXTENSION = '.kiure';
const VAULT_REGISTER_FILE_NAME = 'register.reg';
const VAULTS_DIR_NAME = 'vaults';
const LOCAL_CACHE_DIR_NAME = 'cache';
const REMOTE_ROOT_PATH = 'cache';
final GROUP_ALL = AccountGroup(
  name: 'Todos',
  color: Colors.blue.shade700.value,
  iconName: 'assets/svg_icons/widgets.svg',
  id: -1,
  modifDate: DateTime.now(),
  status: LifeStatus.active,
);
