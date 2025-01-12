import 'package:url_launcher/url_launcher_string.dart';

class WebLauncher {
  static Future<void> launch(String url) async {
    await launchUrlString(url);
  }
}
