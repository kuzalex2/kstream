

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
  final FlutterRtmpStreamer streamer;

  StreamSubscription? _sub1;

  SettingsCubit({required this.repository, required this.streamer}) : super(SettingsState(streamingState: streamer.state)) {

    _sub1 = streamer.stateStream.listen((streamingState) =>
        emit(state.copyWith(streamingState: streamingState)));
  }

  changeStreamingSettings(StreamingSettings newValue) async {
    if (isClosed) {
      return;
    }

    await streamer.changeStreamingSettings(newValue);

    /// save
    ///
    repository.sharedPreferences.streamingSettings = newValue;
  }

  Future<BackAndFrontResolutions> getResolutions() => streamer.getResolutions();



  @override
  Future<void> close() {
    _sub1?.cancel();
    _sub1 = null;
    return super.close();
  }


  //
  // consumeError(){
  //   emit(state.copyWith(error: ""));
  // }


}
