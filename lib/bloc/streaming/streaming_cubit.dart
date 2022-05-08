

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rtmp_streamer/flutter_rtmp_streamer.dart';
import 'package:kstream/repository/repository.dart';


part 'streaming_state.dart';



class MyStreamingCubit extends Cubit<MyStreamingState>  {

  final Repository repository;
  FlutterRtmpStreamer? _streamer;

  StreamSubscription? _sub1;
  StreamSubscription? _sub2;



  MyStreamingCubit({required this.repository}) : super(MyStreamingState.empty) {

    _init();
  }

  _init() async {

    try {
      _streamer = await repository.streamerRepository.streamer();

    } catch (e) {
      emit(state.copyWith(fatalError: e.toString(), initialized: false));
      return;
    }

    emit(state.copyWith(initialized: true, resolution: _streamer!.state.resolution, audioMuted: _streamer!.state.isAudioMuted));

    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(showLiveButton: state.initialized && !_streamer!.state.isStreaming));


    _sub1 = _streamer!.stateStream.listen((streamingState) {

      final ConnectState connectState;
      if ( streamingState.isRtmpConnected ) {
        connectState = ConnectState.onAir;
      } else if (streamingState.isStreaming){
        connectState = ConnectState.connecting;
      } else {
        connectState = ConnectState.ready;
      }

      emit(state.copyWith(
        showLiveButton: state.initialized && !streamingState.isStreaming,
        connectState: connectState,
        resolution: streamingState.resolution,
        audioMuted: streamingState.isAudioMuted,
      ));
    });

    _sub2 = _streamer!.notificationStream.listen(
            (event) =>
                emit(state.copyWith(error: event.description))
    );
  }

  startStream() {


    try {

      _streamer?.startStream(
          uri: "rtmp://flutter-webrtc.kuzalex.com/live",
          streamName: "one"
      );
    } catch(e){
      emit(state.copyWith(error: e.toString()));
    }

  }

  stopStream() {

    try {
      _streamer?.stopStream();

    } catch(e){
      emit(state.copyWith(error: e.toString()));
    }

  }

  switchCamera() {

    if (_streamer == null) {
      return;
    }

    try {
      _streamer!.changeStreamingSettings(_streamer!.state.streamingSettings.copyWith(
        cameraFacing: _streamer!.state.streamingSettings.cameraFacing == StreamingCameraFacing.back
            ? StreamingCameraFacing.front : StreamingCameraFacing.back
      ));

    } catch(e){
      emit(state.copyWith(error: e.toString()));
    }

  }

  switchMicrophone() {

    if (_streamer == null) {
      return;
    }

    try {
      _streamer!.changeStreamingSettings(_streamer!.state.streamingSettings.copyWith(
          muteAudio: !_streamer!.state.isAudioMuted
      ));

    } catch(e){
      emit(state.copyWith(error: e.toString()));
    }

  }




  @override
  Future<void> close() {
    _sub1?.cancel();
    _sub2?.cancel();
    _sub1 = null;
    _sub2 = null;
    _streamer = null;
    return super.close();
  }


  consumeError(){
    emit(state.copyWith(error: ""));
  }


}
