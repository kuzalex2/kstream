
part of 'repository.dart';


class DeviceInfoRepository {

  late final PackageInfo packageInfo;

  Future init() async {
    packageInfo = await PackageInfo.fromPlatform();
  }


}
