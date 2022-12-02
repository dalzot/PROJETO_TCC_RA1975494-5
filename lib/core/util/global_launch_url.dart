import 'package:url_launcher/url_launcher.dart';

class GlobalLaunchUrlFunction {
  Future<void> launchURL(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> launch(Uri url) async {
    await launch(url);
  }
}
