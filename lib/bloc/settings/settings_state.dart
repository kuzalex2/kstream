
part of 'settings_cubit.dart';


class SettingsState extends Equatable {

  final StreamingState streamingState;
  final StreamEndpointsList endpointsList;

  // final bool initialized;
  // final String error;
  // final String fatalError;
  // final bool showLiveButton;
  // final ConnectState connectState;
  // final Resolution resolution;
  // final bool audioMuted;
  //
  //
  //
  const SettingsState( {
    required this.streamingState,
    required this.endpointsList,
  //   required this.fatalError,
  //   required this.showLiveButton,
  //   required this.connectState,
  //   required this.resolution,
  //   required this.audioMuted,
  });
  //
  // static const empty = SettingsState(
  //   initialized: false,
  //   error: "",
  //   fatalError: "",
  //   showLiveButton: false,
  //   connectState: ConnectState.no,
  //   resolution: Resolution(1, 1),
  //   audioMuted: false,
  // );
  //
  SettingsState copyWith({
    StreamingState? streamingState,
    StreamEndpointsList? endpointsList,

  //   String? fatalError,
  //   bool? showLiveButton,
  //   ConnectState? connectState,
  //   Resolution? resolution,
  //   bool? audioMuted,
  //
  }) {
    return SettingsState(
      streamingState: streamingState ?? this.streamingState,
      endpointsList: endpointsList ?? this.endpointsList,
  //     fatalError: fatalError ?? this.fatalError,
  //     showLiveButton: showLiveButton ?? this.showLiveButton,
  //     connectState: connectState ?? this.connectState,
  //     resolution: resolution ?? this.resolution,
  //     audioMuted: audioMuted ?? this.audioMuted,
    );
  }

  @override
  List<Object> get props => [
    streamingState,
    endpointsList,
    // showLiveButton,
    // fatalError,
    // connectState,
    // resolution,
    // audioMuted,
  ];
}


