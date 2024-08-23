import 'package:url_launcher/url_launcher_string.dart';

bool isURL(String value) {
  if (value.isNotEmpty) {
    return value.contains('.') && Uri.tryParse(value) != null;
  }
  return false;
}

Future<bool> launchAnyURL(String? url) async {
  if (url == null) {
    return false;
  }
  String finalURL = url;
  if (!url.startsWith('http')) {
    finalURL = 'https://$url';
  }
  if (!await launchUrlString(finalURL, mode: LaunchMode.externalApplication)) {
    finalURL = 'http://$url';
    return await launchUrlString(finalURL,
        mode: LaunchMode.externalApplication);
  }
  return true;
}
