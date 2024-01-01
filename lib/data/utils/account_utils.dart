import 'package:kyure/data/models/vault_data.dart';

class AccountUtils {
  static bool assignId(Account account, Map<int, Account> accounts) {
    int id = hashAccount(account);
    Account? accountFound = accounts[id];
    if (accountFound != null) {
      do {
        if (accountFound?.name == account.name &&
            accountFound?.fieldUsername.data == account.fieldUsername.data) {
          return false;
        }
        id = getNextId(id, accounts);
        accountFound = accounts[id];
      } while (accounts.containsKey(id));
      account.id = id;
      return true;
    } else {
      account.id = id;
      accounts[id] = account;
      return true;
    }
  }

  static int getNextId(int id, Map<int, Account> accounts) {
    int nextId = id;
    while (accounts.containsKey(nextId)) {
      nextId++;
    }
    return nextId;
  }

  static int hashAccount(Account account) {
    return account.name.hashCode ^ account.fieldUsername.data.hashCode;
  }

  static String simplifyName(Account account) {
    return account.name
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ñ', 'n');
  }

  static Account generateEmptyAccount() {
    return Account(
        id: -1,
        groupId: -1,
        modifDate: DateTime.now(),
        status: LifeStatus.active,
        name: '',
        image: ImageSource(
            source: ImageSourceType.asset,
            path: 'assets/web_icons/squared.png'),
        fieldUsername: AccountField(name: 'Nombre de usuario', data: ''),
        fieldPassword:
            AccountField(name: 'Contraseña', data: '', visible: false));
  }
}
