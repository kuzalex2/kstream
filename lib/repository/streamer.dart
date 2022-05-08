
part of 'repository.dart';


class StreamerRepository {

  final SharedPreferencesRepository sharedPreferencesRepository;

  StreamerRepository(this.sharedPreferencesRepository);

  FlutterRtmpStreamer? _streamer;

  Future<FlutterRtmpStreamer> streamer() async {

    return _streamer ??= await FlutterRtmpStreamer.init(
        sharedPreferencesRepository.streamingSettings
    );
  }

}
