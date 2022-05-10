
part of 'repository.dart';


class StreamerRepository {

  final SharedPreferencesRepository sharedPreferencesRepository;

  StreamerRepository(this.sharedPreferencesRepository):
        _streamEndpointsList = sharedPreferencesRepository.streamEndpointsList;



  StreamEndpointsList get streamEndpointsList => _streamEndpointsList;
  set streamEndpointsList(StreamEndpointsList newList){
    _streamEndpointsList = newList;

    sharedPreferencesRepository.streamEndpointsList = _streamEndpointsList;
  }

  FlutterRtmpStreamer? _streamer;
  StreamEndpointsList _streamEndpointsList;

  Future<FlutterRtmpStreamer> streamer() async {
    return _streamer ??= await FlutterRtmpStreamer.init(
        sharedPreferencesRepository.streamingSettings
    );
  }

}
