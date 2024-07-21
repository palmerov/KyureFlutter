import 'dart:io';

import 'package:path_provider/path_provider.dart';

String concatPath(String parent, String child, [bool remote = false]) {
  if (Platform.isWindows && !remote) {
    return '$parent\\$child';
  } else {
    return '$parent/$child';
  }
}

String concatPathNames(List<String> names, [bool remote = false]) {
  if (Platform.isWindows && !remote) {
    return names.fold('', (previousValue, element) => '$previousValue\\$element');
  } else {
    return names.fold('', (previousValue, element) => '$previousValue/$element');
  }
}

Future<Directory> getLocalInternalRootDir() async {
  if (Platform.isAndroid) {
    return await Directory(
            concatPath((await getApplicationSupportDirectory()).path, 'kiure'))
        .create(recursive: true);
  } else {
    return await Directory(concatPath(
            (await getApplicationDocumentsDirectory()).path, 'kiure'))
        .create(recursive: true);
  }
}
