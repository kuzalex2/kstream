
part of 'cubit.dart';


class MyStreamingState extends Equatable {

  final bool initialized;
  final String error;
  final String fatalError;
  final bool showLiveButton;
  // final StreamingState streamingState;
  // final StreamingNotification streamingNotification;



  const MyStreamingState( {
    required this.initialized,
    required this.error,
    required this.fatalError,
    required this.showLiveButton,
  });

  static const empty = MyStreamingState(
    initialized: false,
    error: "",
    fatalError: "",
    showLiveButton: false,
  );

  MyStreamingState copyWith({
    bool? initialized,
    String? error,
    String? fatalError,
    bool? showLiveButton,

  }) {
    return MyStreamingState(
      initialized: initialized ?? this.initialized,
      error: error ?? this.error,
      fatalError: fatalError ?? this.fatalError,
      showLiveButton: showLiveButton ?? this.showLiveButton,
    );
  }

  @override
  List<Object> get props => [
    initialized,
    error,
    showLiveButton,
    fatalError,
  ];
}


