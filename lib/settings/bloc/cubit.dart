
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rtmp_streamer/flutter_rtmp_streamer.dart';
import 'package:kstream/repository/repository.dart';

part 'state.dart';


class SettingsCubit extends Cubit<SettingsState>  {

  final Repository repository;
  FlutterRtmpStreamer? _streamer;

  StreamSubscription? _sub1;

  SettingsCubit({required this.repository}) : super(const SettingsState(streamingState: StreamingState.empty)) {
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



  @override
  Future<void> close() {
    _sub1?.cancel();
    _sub1 = null;
    _streamer = null;
    return super.close();
  }


}
