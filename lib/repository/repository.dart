import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_rtmp_streamer/flutter_rtmp_streamer.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kstream/models/stream_endpoint.dart';


part 'shared_preferences_repository.dart';
part 'device_info.dart';
part 'streamer.dart';


class Repository {

  late final SharedPreferencesRepository sharedPreferences;
  late final DeviceInfoRepository deviceInfo;
  late final StreamerRepository streamerRepository;

  init() async {

    sharedPreferences = SharedPreferencesRepository();
    deviceInfo = DeviceInfoRepository();

    await sharedPreferences.init();
    await deviceInfo.init();

    streamerRepository = StreamerRepository(sharedPreferences);
  }


}
