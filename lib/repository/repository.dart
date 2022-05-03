import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';


part 'shared_preferences_repository.dart';
part 'device_info.dart';


class Repository {

  late final SharedPreferencesRepository sharedPreferences;
  late final DeviceInfoProvider deviceInfo;

  init() async {

    sharedPreferences = SharedPreferencesRepository();
    deviceInfo = DeviceInfoProvider();

    await sharedPreferences.init();
    await deviceInfo.init();
  }


}
