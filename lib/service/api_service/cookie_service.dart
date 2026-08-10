import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class CookieService {
  CookieService._();

  static final CookieService instance = CookieService._();

  late PersistCookieJar cookieJar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    cookieJar = PersistCookieJar(
      ignoreExpires: false,
      storage: FileStorage(
        '${dir.path}/cookies',
      ),
    );
  }
}