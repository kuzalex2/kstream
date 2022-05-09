
part of 'repository.dart';


class StreamerRepository {

  final SharedPreferencesRepository sharedPreferencesRepository;

  StreamerRepository(this.sharedPreferencesRepository):
      ///FIXME
        // _streamEndpointsList = sharedPreferencesRepository.streamEndpointsList;
    _streamEndpointsList = const StreamEndpointsList(
        list: [
          StreamEndpoint(active: true, name: 'flutter-webrtc.kuzalex.com', url: 'rtmp://flutter-webrtc.kuzalex.com/live', key: 'one'),
          StreamEndpoint(active: false, name: 'second', url: 'rtmp://flutter-webrtc.kuzalex.com/live', key: 'one'),
          StreamEndpoint(active: false, name: 'third', url: 'rtmp://flutter-webrtc.kuzalex.com/live', key: 'one'),
        ],
    );


  StreamEndpointsList get streamEndpointsList => _streamEndpointsList;
  set streamEndpointsList(StreamEndpointsList newList){
    _streamEndpointsList = newList;
    ///FIXME

    // sharedPreferencesRepository.streamEndpointsList = _streamEndpointsList;
  }

  FlutterRtmpStreamer? _streamer;
  StreamEndpointsList _streamEndpointsList;

  Future<FlutterRtmpStreamer> streamer() async {
    return _streamer ??= await FlutterRtmpStreamer.init(
        sharedPreferencesRepository.streamingSettings
    );
  }

}
