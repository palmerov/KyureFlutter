import 'dart:io';

String concatPath(String parent, String child) {
  if (Platform.isWindows) {
    return '$parent\\$child';
  } else {
    return '$parent/$child';
  }
}
