
part of 'repository.dart';


class DeviceInfoProvider {

  late final PackageInfo packageInfo;

  Future init() async {
    packageInfo = await PackageInfo.fromPlatform();
  }


}
