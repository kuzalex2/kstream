
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




  ///
  /// Flutter RTMP Streamer Settings
  ///

  set streamingSettings(StreamingSettings value) {
    _prefs.setString("streamingSettings", jsonEncode(value.toJson()));
  }

  StreamingSettings get streamingSettings {
    final saved = _prefs.getString("streamingSettings");
    if (saved != null) {
      try {
        return StreamingSettings.fromJson(jsonDecode(saved));

      } catch (e){
        debugPrint("get streamingSettings failed: $e");

      }
    }

    return StreamingSettings.initial;
  }



  ///
  /// Flutter RTMP Streamer Settings
  ///

  set streamEndpointsList(StreamEndpointsList value) =>
    _prefs.setString("streamEndpointsList", jsonEncode(value.toJson()));


  StreamEndpointsList get streamEndpointsList {
    final saved = _prefs.getString("streamEndpointsList");
    if (saved != null) {
      try {
        return StreamEndpointsList.fromJson( json.decode(saved) );

      } catch (e){
        debugPrint("get streamEndpointsList failed: $e");

      }
    }

    return StreamEndpointsList.empty;
  }




}