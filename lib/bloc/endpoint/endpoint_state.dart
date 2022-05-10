

part of 'endpoint_cubit.dart';



class EditEndpointState extends Equatable {

  final String initialEndpointName;
  final String initialStreamingURL;
  final String initialStreamKey;

  final EndpointNameInput endpointNameInput;
  final StreamingURLInput streamingURLInput;
  final StreamKeyInput streamKeyInput;

  final FormzStatus status;
  final String error;


  bool get hasChanges => initialEndpointName != endpointNameInput.value
      || initialStreamingURL != streamingURLInput.value
      || initialStreamKey != streamKeyInput.value;


  const EditEndpointState( {
    required this.initialEndpointName,
    required this.initialStreamingURL,
    required this.initialStreamKey,

    required this.endpointNameInput,
    required this.streamingURLInput,
    required this.streamKeyInput,
    required this.status,
    required this.error,
  });

  factory EditEndpointState.initial({
    required String initialEndpointName,
    required String initialStreamingURL,
    required String initialStreamKey,
  }) {

    return EditEndpointState(
      initialEndpointName: initialEndpointName,
      initialStreamingURL: initialStreamingURL,
      initialStreamKey:initialStreamKey,
      endpointNameInput: EndpointNameInput.pure(initialEndpointName),
      streamingURLInput: StreamingURLInput.pure(initialStreamingURL),
      streamKeyInput: StreamKeyInput.pure(initialStreamKey),
      error: '',
      status: Formz.validate([EndpointNameInput.dirty(initialEndpointName), StreamingURLInput.dirty(initialStreamingURL), StreamKeyInput.dirty(initialStreamKey) ]),

    );
  }

  EditEndpointState copyWith({
    EndpointNameInput? endpointNameInput,
    StreamingURLInput? streamingURLInput,
    StreamKeyInput? streamKeyInput,

    FormzStatus? status,
    String? error,
  }) {
    return EditEndpointState(
      initialEndpointName: initialEndpointName,
      initialStreamingURL: initialStreamingURL,
      initialStreamKey: initialStreamKey,

      endpointNameInput: endpointNameInput ?? this.endpointNameInput,
      streamingURLInput: streamingURLInput ?? this.streamingURLInput,
      streamKeyInput: streamKeyInput ?? this.streamKeyInput,
      status: status ?? this.status,
      error: error ?? this.error,

    );
  }

  @override
  List<Object> get props => [
    initialEndpointName,
    initialStreamingURL,
    initialStreamKey,
    endpointNameInput,
    streamingURLInput,
    streamKeyInput,
    status,
    error,
  ];
}


