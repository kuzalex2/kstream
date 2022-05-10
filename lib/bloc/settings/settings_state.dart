
part of 'settings_cubit.dart';


class SettingsState extends Equatable {

  final StreamingState streamingState;
  final StreamEndpointsList endpointsList;

  const SettingsState( {
    required this.streamingState,
    required this.endpointsList,
  });

  SettingsState copyWith({
    StreamingState? streamingState,
    StreamEndpointsList? endpointsList,
  }) {
    return SettingsState(
      streamingState: streamingState ?? this.streamingState,
      endpointsList: endpointsList ?? this.endpointsList,
    );
  }

  @override
  List<Object> get props => [
    streamingState,
    endpointsList,
  ];
}


