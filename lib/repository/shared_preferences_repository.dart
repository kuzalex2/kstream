
part of 'repository.dart';


class SharedPreferencesRepository {

  late final SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }



  ///
  /// Application Locale
  ///
  String? get languageCode => _prefs.getString("languageCode");


  set languageCode(String? v)  {
    if (v!=null) {
      _prefs.setString('languageCode', v);
    }
  }




  ///
  /// isMicPermissionKnown
  ///

  bool get isMicPermissionKnown => _prefs.getBool("isMicPermissionKnown") ?? false;

  set isMicPermissionKnown(bool value)  {
    _prefs.setBool("isMicPermissionKnown", value);
  }



  ///
  /// isCamPermissionKnown
  ///
  bool get isCamPermissionKnown => _prefs.getBool("isCamPermissionKnown") ?? false;

  set isCamPermissionKnown(bool value)  {
    _prefs.setBool("isCamPermissionKnown", value);
  }


}