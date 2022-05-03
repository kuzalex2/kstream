

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
  final Repository _repository;
  late final FlutterRtmpStreamer streamer;

  StreamSubscription? _sub1;
  StreamSubscription? _sub2;



  MyStreamingCubit(this._repository) : super(MyStreamingState.empty) {
    WidgetsBinding.instance?.addObserver(this);

    _init();
  }

  _init() async {

    _repository.sharedPreferences;

    try {
      streamer = await FlutterRtmpStreamer.init(StreamingSettings.initial);
    } catch (e) {
      emit(state.copyWith(error: e.toString(), initialized: false));
    }

    emit(state.copyWith(initialized: true));

    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(showLiveButton: state.initialized && !streamer.state.isStreaming));

    _sub1 = streamer.stateStream.listen((streamingState) {
      emit(state.copyWith(showLiveButton: state.initialized && !streamingState.isStreaming));
    });

    _sub2 = streamer.notificationStream.listen((event) {

    });
  }

  startStream() {
    if (!state.initialized)
      return;

    try {
      streamer.startStream(
          uri: "rtmp://flutter-webrtc.kuzalex.com/live",
          streamName: "one"
      );
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
