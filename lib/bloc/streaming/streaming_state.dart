
part of 'streaming_cubit.dart';

enum ConnectState {
  no,
  ready,
  connecting,
  onAir,
}

class MyStreamingState extends Equatable {

  final bool initialized;
  final String error;
  final String fatalError;
  final bool showLiveButton;
  final ConnectState connectState;
  final Resolution resolution;
  final bool audioMuted;
  final bool showOpenSettings;



  const MyStreamingState( {
    required this.initialized,
    required this.error,
    required this.fatalError,
    required this.showLiveButton,
    required this.connectState,
    required this.resolution,
    required this.audioMuted,
    required this.showOpenSettings,
  });

  static const empty = MyStreamingState(
    initialized: false,
    error: "",
    fatalError: "",
    showLiveButton: false,
    connectState: ConnectState.no,
    resolution: Resolution(1, 1),
    audioMuted: false,
    showOpenSettings: false,
  );

  MyStreamingState copyWith({
    bool? initialized,
    String? error,
    String? fatalError,
    bool? showLiveButton,
    ConnectState? connectState,
    Resolution? resolution,
    bool? audioMuted,
    bool? showOpenSettings,

  }) {
    return MyStreamingState(
      initialized: initialized ?? this.initialized,
      error: error ?? this.error,
      fatalError: fatalError ?? this.fatalError,
      showLiveButton: showLiveButton ?? this.showLiveButton,
      connectState: connectState ?? this.connectState,
      resolution: resolution ?? this.resolution,
      audioMuted: audioMuted ?? this.audioMuted,
      showOpenSettings: showOpenSettings ?? this.showOpenSettings,
    );
  }

  @override
  List<Object> get props => [
    initialized,
    error,
    showLiveButton,
    fatalError,
    connectState,
    resolution,
    audioMuted,
    showOpenSettings,
  ];
}


