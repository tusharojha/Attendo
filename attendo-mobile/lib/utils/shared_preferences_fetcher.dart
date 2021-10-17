import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesFetcher {
  static SharedPreferences? _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setEnrollmentNumber(int enrollmentNumber) async =>
      await _preferences!.setInt('enrollmentNumber', enrollmentNumber);

  static Future getEnrollmentNumber() async =>
      _preferences!.getInt('enrollmentNumber');
}
