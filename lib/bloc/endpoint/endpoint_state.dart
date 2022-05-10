

part of 'endpoint_cubit.dart';



class EditEndpointState extends Equatable {

  final StreamEndpoint initialEndpoint;


  final EndpointNameInput endpointNameInput;
  final StreamingURLInput streamingURLInput;
  final StreamKeyInput streamKeyInput;

  final FormzStatus status;
  final String error;


  bool get hasChanges => initialEndpoint.name != endpointNameInput.value
      || initialEndpoint.url != streamingURLInput.value
      || initialEndpoint.key != streamKeyInput.value;


  const EditEndpointState( {
    required this.initialEndpoint,

    required this.endpointNameInput,
    required this.streamingURLInput,
    required this.streamKeyInput,
    required this.status,
    required this.error,
  });

  factory EditEndpointState.initial({
    required StreamEndpoint initialEndpoint,
  }) {

    return EditEndpointState(
      initialEndpoint: initialEndpoint,
      endpointNameInput: EndpointNameInput.pure(initialEndpoint.name),
      streamingURLInput: StreamingURLInput.pure(initialEndpoint.url),
      streamKeyInput: StreamKeyInput.pure(initialEndpoint.key),
      error: '',
      status: Formz.validate([EndpointNameInput.dirty(initialEndpoint.name), StreamingURLInput.dirty(initialEndpoint.url), StreamKeyInput.dirty(initialEndpoint.key) ]),

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
      initialEndpoint: initialEndpoint,

      endpointNameInput: endpointNameInput ?? this.endpointNameInput,
      streamingURLInput: streamingURLInput ?? this.streamingURLInput,
      streamKeyInput: streamKeyInput ?? this.streamKeyInput,
      status: status ?? this.status,
      error: error ?? this.error,

    );
  }

  @override
  List<Object> get props => [
    initialEndpoint,
    endpointNameInput,
    streamingURLInput,
    streamKeyInput,
    status,
    error,
  ];
}


