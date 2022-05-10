
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rtmp_streamer/flutter_rtmp_streamer.dart';
import 'package:kstream/repository/repository.dart';

import '../../models/stream_endpoint.dart';
import 'package:collection/collection.dart';


part 'settings_state.dart';


class SettingsCubit extends Cubit<SettingsState>  {

  final Repository repository;
  FlutterRtmpStreamer? _streamer;

  StreamSubscription? _sub1;

  SettingsCubit({required this.repository}) :
        super(SettingsState(
          streamingState: StreamingState.empty,
          endpointsList: repository.streamerRepository.streamEndpointsList
      ))
  {
    _init();
  }

  _init() async {

    try {
      _streamer = await repository.streamerRepository.streamer();

    } catch (e) {
      return;
    }

    _sub1 = _streamer!.stateStream.listen((streamingState) =>
        emit(state.copyWith(streamingState: streamingState)));
  }


  changeStreamingSettings(StreamingSettings newValue) async {

    if (isClosed || _streamer == null) {
      return;
    }

    await _streamer!.changeStreamingSettings(newValue);

    /// save
    ///
    repository.sharedPreferences.streamingSettings = newValue;
  }

  Future<BackAndFrontResolutions> getResolutions() async {

    if (_streamer == null) {
      return const BackAndFrontResolutions(back: [], front: []);
    }

    return _streamer!.getResolutions();
  }

  setActiveEndpoint(StreamEndpoint? value) {

    final newList = StreamEndpointsList(
        list: state.endpointsList.list.map((e) {
          if (e == value) {
            return e.copyWith(active: true);
          }

          return e.active ? e.copyWith(active: false): e;
        }).toList()
    );

    _saveAndEmit(newList);

  }

  deleteEndpoint(StreamEndpoint value) {

    final newList = StreamEndpointsList(
        list: state.endpointsList.list.where((e) => e != value).toList(),
    );

    _saveAndEmit(newList);

  }

  updateEndpoint(StreamEndpoint oldItem, StreamEndpoint newItem) {

    final newList = StreamEndpointsList(
        list: state.endpointsList.list.map((e) => (e!=oldItem ? e : newItem)).toList()
    );

    _saveAndEmit(newList);

  }

  addNewEndpoint(StreamEndpoint newValue) {


    if (state.endpointsList.list.isEmpty){
      newValue = newValue.copyWith(active: true);
    }

    final newList = StreamEndpointsList(
        list: List.from( state.endpointsList.list )..add(newValue)
    );


    _saveAndEmit(newList);
  }

  _saveAndEmit(StreamEndpointsList newList){
    repository.streamerRepository.streamEndpointsList = newList;
    emit(state.copyWith(endpointsList: newList));
  }


  @override
  Future<void> close() {
    _sub1?.cancel();
    _sub1 = null;
    _streamer = null;
    return super.close();
  }


}
