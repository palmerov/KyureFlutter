import 'package:kyure/data/models/vault_data.dart';

class AccountUtils {
  static bool assignId(Account account, Map<int, Account> accounts) {
    int id = hashAccount(account);
    if (id < 0) {
      id = -id;
    } else if (id == 0) {
      id = 1;
    }
    Account? accountFound = accounts[id];
    String simpleName = simplifyName(account);
    if (accountFound != null) {
      do {
        if (simplifyName(accountFound!) == simpleName &&
            accountFound.fieldUsername.data == account.fieldUsername.data) {
          return false;
        }
        id = getNextId(id, accounts);
        accountFound = accounts[id];
      } while (accounts.containsKey(id));
      account.id = id;
      return true;
    } else {
      if (accounts.values.any((element) =>
          simplifyName(element) == simpleName &&
          element.fieldUsername.data == account.fieldUsername.data)) {
        return false;
      }
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
    return simplifyName(account).hashCode ^
        account.fieldUsername.data.trim().hashCode;
  }

  static String simplifyName(Account account) {
    return account.name
        .trim()
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
}
