import 'package:package_info_plus/package_info_plus.dart';

enum Env {
  prod,
  dev,
}

class FlavorService {
  FlavorService._();

  static Env? env;

  static init(PackageInfo info) {
    final flavor = info.packageName.split(".").last;
    if (flavor == 'dev') {
      env = Env.dev;
    } else {
      env = Env.prod;
    }
  }

  static String get getBaseApi {
    // return prod url
    if (env == Env.prod) {
      return "";
    }
    // return url other than prod one
    return "";
  }

  static String get getORSBaseApi => "https://api.openrouteservice.org";
  static String get getOSRMBaseApi => "http://router.project-osrm.org";

  static String get getORSApiKey =>
      "5b3ce3597851110001cf624833fa518aceae4e1b8fb38866fee91852";

  static String dummyImageUrl =
      'https://evimsreigandkjuinogy.supabase.co/storage/v1/object/public/common/dummy_image.jpg?t=2024-04-02T23%3A04%3A29.105Z';
}
