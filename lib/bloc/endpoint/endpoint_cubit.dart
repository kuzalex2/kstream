import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'endpoint_state.dart';
part '../../models/form_inputs.dart';


class EditEndpointCubit extends Cubit<EditEndpointState>  {




  EditEndpointCubit({
    required String initialEndpointName,
    required String initialStreamingURL,
    required String initialStreamKey,
  }) : super(EditEndpointState.initial(initialEndpointName: initialEndpointName, initialStreamingURL: initialStreamingURL, initialStreamKey: initialStreamKey));



  void endpointNameChanged(String value) {
    final endpointNameInput = EndpointNameInput.dirty(value);
    emit(state.copyWith(
      endpointNameInput: endpointNameInput,
      status: Formz.validate([endpointNameInput, state.streamingURLInput, state.streamKeyInput]),
    ));
  }

  void streamingURLChanged(String value) {
    final streamingURLInput = StreamingURLInput.dirty(value);
    emit(state.copyWith(
      streamingURLInput: streamingURLInput,
      status: Formz.validate([state.endpointNameInput, streamingURLInput, state.streamKeyInput]),
    ));
  }

  void streamKeyChanged(String value) {
    final streamKeyInput = StreamKeyInput.dirty(value);
    emit(state.copyWith(
      streamKeyInput: streamKeyInput,
      status: Formz.validate([state.endpointNameInput, state.streamingURLInput, streamKeyInput]),
    ));
  }

  // final Repository repository;
  // FlutterRtmpStreamer? _streamer;
  //
  // StreamSubscription? _sub1;
  //
  // EditEndpointCubit({required this.repository}) :
  //       super(SettingsState(
  //         streamingState: StreamingState.empty,
  //         endpointsList: repository.streamerRepository.streamEndpointsList
  //     ))
  // {
  //   _init();
  // }

  // _init() async {
  //
  //   try {
  //     _streamer = await repository.streamerRepository.streamer();
  //
  //   } catch (e) {
  //     return;
  //   }
  //
  //   _sub1 = _streamer!.stateStream.listen((streamingState) =>
  //       emit(state.copyWith(streamingState: streamingState)));
  // }
  //
  //
  // changeStreamingSettings(StreamingSettings newValue) async {
  //
  //   if (isClosed || _streamer == null) {
  //     return;
  //   }
  //
  //   await _streamer!.changeStreamingSettings(newValue);
  //
  //   / save
  //   /
    // repository.sharedPreferences.streamingSettings = newValue;
  // }
  //
  // Future<BackAndFrontResolutions> getResolutions() async {
  //
  //   if (_streamer == null) {
  //     return const BackAndFrontResolutions(back: [], front: []);
  //   }
  //
  //   return _streamer!.getResolutions();
  // }
  //
  // setActiveEndpoint(StreamEndpoint? value) {
  //
  //   final newList = StreamEndpointsList(
  //       list: state.endpointsList.list.map((e) {
  //         if (e == value) {
  //           return e.copyWith(active: true);
  //         }
  //
  //         return e.active ? e.copyWith(active: false): e;
  //       }).toList()
  //   );
  //
  //   repository.streamerRepository.streamEndpointsList = newList;
  //
  //   emit(state.copyWith(endpointsList: newList));
  // }
  //
  // deleteEndpoint(StreamEndpoint value) {
  //
  //   final newList = StreamEndpointsList(
  //       list: state.endpointsList.list.where((e) => e != value).toList(),
  //   );
  //
  //   repository.streamerRepository.streamEndpointsList = newList;
  //
  //   emit(state.copyWith(endpointsList: newList));
  // }
  //
  //
  //
  //
  //
  //
  //
  //
  // @override
  // Future<void> close() {
  //   _sub1?.cancel();
  //   _sub1 = null;
  //   _streamer = null;
  //   return super.close();
  // }
//

}
