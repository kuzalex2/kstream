
part of 'cubit.dart';

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
  // final StreamingState streamingState;
  // final StreamingNotification streamingNotification;



  const MyStreamingState( {
    required this.initialized,
    required this.error,
    required this.fatalError,
    required this.showLiveButton,
    required this.connectState,
    required this.resolution,
  });

  static const empty = MyStreamingState(
    initialized: false,
    error: "",
    fatalError: "",
    showLiveButton: false,
    connectState: ConnectState.no,
    resolution: Resolution(1, 1),
  );

  MyStreamingState copyWith({
    bool? initialized,
    String? error,
    String? fatalError,
    bool? showLiveButton,
    ConnectState? connectState,
    Resolution? resolution,

  }) {
    return MyStreamingState(
      initialized: initialized ?? this.initialized,
      error: error ?? this.error,
      fatalError: fatalError ?? this.fatalError,
      showLiveButton: showLiveButton ?? this.showLiveButton,
      connectState: connectState ?? this.connectState,
      resolution: resolution ?? this.resolution,
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
  ];
}


