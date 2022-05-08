

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rtmp_streamer/flutter_rtmp_streamer.dart';
import 'package:kstream/repository/repository.dart';


part 'state.dart';



class MyStreamingCubit extends Cubit<MyStreamingState> with  WidgetsBindingObserver {

  // AppLifecycleState? _prevState;
  final Repository repository;
  late final FlutterRtmpStreamer streamer;

  StreamSubscription? _sub1;
  StreamSubscription? _sub2;



  MyStreamingCubit(this.repository) : super(MyStreamingState.empty) {
    WidgetsBinding.instance?.addObserver(this);

    _init();
  }

  _init() async {



    repository.sharedPreferences;

    try {
      streamer = await FlutterRtmpStreamer.init(
          repository.sharedPreferences.streamingSettings
          // .copyWith(
              // resolution: const Resolution(720, 720),
          // )
      );
    } catch (e) {
      emit(state.copyWith(fatalError: e.toString(), initialized: false));
      return;
    }

    emit(state.copyWith(initialized: true, resolution: streamer.state.resolution, audioMuted: streamer.state.isAudioMuted));

    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(showLiveButton: state.initialized && !streamer.state.isStreaming));


    _sub1 = streamer.stateStream.listen((streamingState) {

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

    _sub2 = streamer.notificationStream.listen(
            (event) =>
                emit(state.copyWith(error: event.description))
    );
  }

  startStream() {
    if (!state.initialized) {
      return;
    }

    try {
      streamer.startStream(
          uri: "rtmp://flutter-webrtc.kuzalex.com/live",
          streamName: "one"
      );
    } catch(e){
      emit(state.copyWith(error: e.toString()));
    }

  }

  stopStream() {

    if (!state.initialized) {
      return;
    }

    try {
      streamer.stopStream();

    } catch(e){
      emit(state.copyWith(error: e.toString()));
    }

  }

  switchCamera() {

    if (!state.initialized) {
      return;
    }

    try {
      streamer.changeStreamingSettings(streamer.state.streamingSettings.copyWith(
        cameraFacing: streamer.state.streamingSettings.cameraFacing == StreamingCameraFacing.back
            ? StreamingCameraFacing.front : StreamingCameraFacing.back
      ));

    } catch(e){
      emit(state.copyWith(error: e.toString()));
    }

  }

  switchMicrophone() {

    if (!state.initialized) {
      return;
    }

    try {
      streamer.changeStreamingSettings(streamer.state.streamingSettings.copyWith(
          muteAudio: !streamer.state.isAudioMuted
      ));

    } catch(e){
      emit(state.copyWith(error: e.toString()));
    }

  }




  @override
  Future<void> close() {
    WidgetsBinding.instance?.removeObserver(this);
    _sub1?.cancel();
    _sub2?.cancel();
    _sub1 = null;
    _sub2 = null;
    return super.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
  }

  consumeError(){
    emit(state.copyWith(error: ""));
  }


}
