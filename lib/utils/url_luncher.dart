import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  /// শুধু URL দিলে কাজ করবে, যদি protocol না থাকে তাহলে auto 'https://' add করবে
  static Future<void> open(String url) async {
    // যদি URL http/https দিয়ে শুরু না হয়, তাহলে https:// add করবে
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
