import 'dart:io';

import 'package:path_provider/path_provider.dart';

String concatPath(String parent, String child) {
  if (Platform.isWindows) {
    return '$parent\\$child';
  } else {
    return '$parent/$child';
  }
}

Future<Directory> getLocalInternalRootDir() async {
  if (Platform.isAndroid) {
    return await Directory(
            concatPath((await getApplicationSupportDirectory()).path, 'kiure'))
        .create(recursive: true);
  } else {
    return await Directory(
            concatPath((await getApplicationDocumentsDirectory()).path, 'kiure'))
        .create(recursive: true);
  }
}
